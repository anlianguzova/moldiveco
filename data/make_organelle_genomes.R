# Real organelle genomes from NCBI RefSeq for 02_intro_ggplot.qmd (and later sessions).
# Builds data/organelle_genomes.xlsx: 6 groups x 25 genomes, sheet "genomes",
# a "Source: ..." row above the header; and data/mito_map_human.csv, the gene
# map of the human mitogenome for the dataset slide.
# Downloads live RefSeq through NCBI E-utilities: a rerun on a later date can pick
# different records. Current file: downloaded 2026-10-31.
# Rerun from the project folder: source("data/make_organelle_genomes.R") (~10 min).

# install.packages(c("rentrez", "xml2", "openxlsx"))

download_date <- Sys.Date()
set.seed(2026)
n_per_group <- 25

# Search terms ####
groups <- data.frame(
  group = c("vertebrates", "insects", "cnidarians", "fungi", "land plants", "land plants"),
  organelle = c(rep("mitochondrion", 5), "plastid"),
  term = c(
    "Vertebrata[orgn] AND mitochondrion[filter] AND refseq[filter]",
    "Insecta[orgn] AND mitochondrion[filter] AND refseq[filter]",
    "Cnidaria[orgn] AND mitochondrion[filter] AND refseq[filter] NOT Myxozoa[orgn]",
    "Fungi[orgn] AND mitochondrion[filter] AND refseq[filter]",
    "Embryophyta[orgn] AND mitochondrion[filter] AND refseq[filter]",
    "Embryophyta[orgn] AND chloroplast[filter] AND refseq[filter]"
  )
)

# Species whose genome is split into several RefSeq records: summed into one row
split_species <- c("Hydra vulgaris", "Cucumis sativus", "Spizellomyces punctatus")
# Records included on purpose because their tRNA genes are not annotated (NA, not 0)
na_examples <- c("NC_049065.1",  # Anemonia sulcata, cnidarians
                 "NC_047219.1",  # Heteractis aurora, cnidarians
                 "NC_062588.1")  # Potentilla micrantha, land plants mitochondrion
# Records checked by hand and replaced by the next candidate
exclude_records <- c("NC_016704.1")  # Tapena vasava: 24 tRNAs, extra ones without anticodons
# Records checked by hand and kept, with a note
manual_notes <- c(
  "NC_029695.1" = "tRNA count unusual for a scleractinian coral (normally 2); possible annotation error",
  "NC_027671.1" = "two tRNA-Met annotated; may be a real duplication"
)

# Record summaries for each group ####
library(rentrez)

get_summaries <- function(term) {
  s <- entrez_search("nuccore", term, use_history = TRUE, retmax = 0)
  res <- list()
  for (start in seq(0, s$count - 1, by = 500)) {
    x <- entrez_summary("nuccore", web_history = s$web_history,
                        retstart = start, retmax = 500)
    res[[length(res) + 1]] <- data.frame(
      accession = extract_from_esummary(x, "accessionversion"),
      organism = extract_from_esummary(x, "organism"),
      taxid = as.character(extract_from_esummary(x, "taxid")),
      title = extract_from_esummary(x, "title"),
      completeness = as.character(extract_from_esummary(x, "completeness")),
      slen = as.numeric(extract_from_esummary(x, "slen")),
      row.names = NULL
    )
    Sys.sleep(0.4)
  }
  do.call(rbind, res)
}

summ <- list()
for (i in seq_len(nrow(groups))) {
  s <- get_summaries(groups$term[i])
  s$group <- groups$group[i]
  s$organelle <- groups$organelle[i]
  summ[[i]] <- s
}
summ <- do.call(rbind, summ)

# Exclusions ####
# Only curated complete RefSeq records (NC_): drops NW_ scaffolds
summ <- summ[startsWith(summ$accession, "NC_") & summ$completeness == "complete", ]
summ <- summ[!grepl("partial|plasmid", summ$title, ignore.case = TRUE), ]
# No hybrids, e.g. "Liriodendron x sinoamericanum"
summ <- summ[!grepl(" x ", summ$organism), ]
# Single "chromosome N" records: the rest of the genome is not in RefSeq
split_taxids <- unique(summ$taxid[summ$organism %in% split_species])
summ <- summ[!grepl("chromosome", summ$title, ignore.case = TRUE) | summ$taxid %in% split_taxids, ]
# One record per species (several records only for the split species)
summ <- summ[!duplicated(summ[, c("taxid", "group", "organelle")]) | summ$taxid %in% split_taxids, ]

# Family of each candidate, to spread the sample across families ####
library(xml2)

get_families <- function(taxids) {
  fam <- character(0)
  for (chunk in split(taxids, ceiling(seq_along(taxids) / 100))) {
    x <- read_xml(entrez_fetch("taxonomy", id = chunk, rettype = "xml"))
    for (tx in xml_find_all(x, "/TaxaSet/Taxon")) {
      f <- xml_text(xml_find_first(tx, "LineageEx/Taxon[Rank='family']/ScientificName"))
      fam[xml_text(xml_find_first(tx, "TaxId"))] <- f
    }
    Sys.sleep(0.4)
  }
  fam
}

# GenBank records ####
fetch_gb <- function(acc) {
  out <- character(0)
  for (chunk in split(acc, ceiling(seq_along(acc) / 10))) {
    out <- c(out, entrez_fetch("nuccore", id = chunk, rettype = "gbwithparts", retmode = "text"))
    Sys.sleep(0.4)
  }
  recs <- unlist(strsplit(paste(out, collapse = "\n"), "\n//\n"))
  recs <- recs[grepl("LOCUS", recs)]
  names(recs) <- sub("(?s).*?\nVERSION +(\\S+).*", "\\1", recs, perl = TRUE)
  recs
}

# Parses one GenBank record: features with their qualifiers, and the sequence
parse_gb <- function(rec) {
  lines <- strsplit(rec, "\n")[[1]]
  ft_start <- grep("^FEATURES", lines)
  or_start <- grep("^ORIGIN", lines)
  seq <- toupper(gsub("[^a-zA-Z]", "", paste(lines[(or_start + 1):length(lines)], collapse = "")))
  ft <- lines[(ft_start + 1):(or_start - 1)]
  ft <- ft[!grepl("^CONTIG", ft)]
  feats <- list()
  for (l in ft) {
    if (grepl("^     \\S", l)) {
      feats[[length(feats) + 1]] <- list(key = trimws(substr(l, 6, 20)),
                                         loc = trimws(substr(l, 22, nchar(l))), q = character(0))
    } else {
      txt <- trimws(l)
      n <- length(feats)
      if (startsWith(txt, "/")) {
        feats[[n]]$q <- c(feats[[n]]$q, txt)
      } else if (length(feats[[n]]$q) == 0) {
        feats[[n]]$loc <- paste0(feats[[n]]$loc, txt)
      } else {
        k <- length(feats[[n]]$q)
        feats[[n]]$q[k] <- paste(feats[[n]]$q[k], txt)
      }
    }
  }
  list(feats = feats, seq = seq)
}

qual <- function(f, name) {
  v <- f$q[startsWith(f$q, paste0("/", name, "="))]
  if (length(v) == 0) return(NA_character_)
  gsub('"', "", sub("^/[^=]+=", "", v[1]))
}

revcomp <- function(s) {
  chartr("ACGT", "TGCA", paste(rev(strsplit(s, "")[[1]]), collapse = ""))
}

# Sequence of a feature, read in the same direction for both strands
feature_seq <- function(loc, seq) {
  r <- regmatches(loc, gregexpr("[0-9]+\\.\\.>?[0-9]+", loc))[[1]]
  s <- paste(vapply(r, function(x) {
    p <- as.numeric(strsplit(gsub(">", "", x), "\\.\\.")[[1]])
    substr(seq, p[1], p[2])
  }, ""), collapse = "")
  min(s, revcomp(s))
}

# Unique protein-coding genes: by gene name, without unnamed ORFs ("orf...") and
# intron-encoded ORFs (fungi: "hypothetical protein", "oi1cob", "cox1-ai1",
# homing endonucleases).
# Unique tRNA genes: by amino acid + anticodon, so the two tRNA-Leu and tRNA-Ser
# genes of animal mitochondria count separately, but the two inverted-repeat
# copies in plastids count once. Anticodon from /anticodon, else from the gene
# name (e.g. "trnS-GCU"), else identical sequences count once.
gene_keys <- function(p) {
  cds <- Filter(function(f) f$key == "CDS" && !any(f$q == "/pseudo"), p$feats)
  cds_names <- vapply(cds, function(f) {
    prod <- qual(f, "product")
    if (!is.na(prod) && grepl("hypothetical|intron|LAGLIDADG|GIY-YIG|homing endonuclease",
                              prod, ignore.case = TRUE)) return(NA_character_)
    n <- qual(f, "gene")
    if (is.na(n)) n <- prod
    tolower(n)
  }, "")
  cds_names <- cds_names[!is.na(cds_names) & !grepl("^orf|^oi[0-9]|-[ab]?i[0-9]+$", cds_names)]
  trna <- Filter(function(f) f$key == "tRNA" && !any(f$q == "/pseudo"), p$feats)
  trna_keys <- vapply(trna, function(f) {
    gene <- qual(f, "gene")
    ac <- sub(".*seq:([a-zA-Z]+).*", "\\1", qual(f, "anticodon"))
    if (is.na(ac) && !is.na(gene) && grepl("-[ACGTUacgtu]{3}$", gene)) {
      ac <- sub(".*-", "", gene)
      gene <- sub("-[^-]*$", "", gene)
      return(paste(tolower(gene), toupper(chartr("Tt", "Uu", ac))))
    }
    n <- qual(f, "product")
    if (is.na(n)) n <- gene
    if (is.na(ac)) ac <- feature_seq(f$loc, p$seq)
    paste(n, toupper(chartr("Tt", "Uu", ac)))
  }, "")
  list(cds = unique(cds_names), trna = unique(trna_keys),
       any_cds = length(cds) > 0, any_trna = length(trna) > 0)
}

# Sampling: the forced records first, then random species, one per family ####
# Mitochondrial records without cox1 annotated have an incomplete annotation:
# skipped, the next candidate is taken instead (same for exclude_records).
has_cox1 <- function(p) {
  any(grepl("^(cox1|coi|co1|coxi|cytochrome c oxidase subunit (i|1))$", gene_keys(p)$cds))
}

chosen <- list()
parsed <- list()
skipped <- character(0)
for (i in seq_len(nrow(groups))) {
  g <- summ[summ$group == groups$group[i] & summ$organelle == groups$organelle[i], ]
  forced <- g[g$taxid %in% split_taxids | g$accession %in% na_examples, ]
  rest <- g[!g$taxid %in% forced$taxid, ]
  rest <- rest[sample(nrow(rest), min(nrow(rest), 4 * n_per_group)), ]
  fam <- get_families(unique(c(forced$taxid, rest$taxid)))
  forced$family <- fam[forced$taxid]
  rest$family <- fam[rest$taxid]
  rest$family[is.na(rest$family)] <- rest$taxid[is.na(rest$family)]
  rest <- rest[!duplicated(rest$family) & !rest$family %in% forced$family, ]
  n_rest <- n_per_group - length(unique(forced$taxid))
  cand <- rest[seq_len(n_rest + 10), ]
  gb <- fetch_gb(c(forced$accession, cand$accession))
  p <- lapply(gb, parse_gb)
  parsed <- c(parsed, p)
  ok <- !cand$accession %in% exclude_records
  if (groups$organelle[i] == "mitochondrion") {
    ok <- ok & vapply(p[cand$accession], has_cox1, TRUE)
  }
  skipped <- c(skipped, cand$accession[!ok])
  cand <- cand[ok, ]
  chosen[[i]] <- rbind(forced, cand[seq_len(n_rest), ])
}
chosen <- do.call(rbind, chosen)

# One row per species ####
rows <- list()
for (sp in split(chosen, paste(chosen$group, chosen$organelle, chosen$taxid))) {
  p <- parsed[sp$accession]
  k <- lapply(p, gene_keys)
  seq <- paste(vapply(p, function(x) x$seq, ""), collapse = "")
  gc <- sum(strsplit(seq, "")[[1]] %in% c("G", "C"))
  acgt <- sum(strsplit(seq, "")[[1]] %in% c("A", "C", "G", "T"))
  annotated <- vapply(k, function(x) x$any_cds, TRUE)
  any_cds <- any(annotated)
  any_trna <- any(vapply(k, function(x) x$any_trna, TRUE))
  note <- NA_character_
  if (nrow(sp) > 1) note <- paste("summed", nrow(sp), "chromosomes")
  if (!any_trna) note <- "tRNA genes not annotated in this record"
  # Split genome with some chromosomes not annotated: gene counts would be partial
  if (nrow(sp) > 1 && !all(annotated)) {
    chrom <- sub(".*chromosome (\\S+),.*", "\\1", sp$title[annotated])
    note <- paste0(note, "; only chromosome ", paste(chrom, collapse = ", "),
                   " annotated, gene counts NA")
    any_cds <- FALSE
    any_trna <- FALSE
  }
  if (any(sp$accession %in% names(manual_notes))) note <- manual_notes[[sp$accession[1]]]
  rows[[length(rows) + 1]] <- data.frame(
    accession = paste(sort(sp$accession), collapse = "; "),
    organism = sub(" mitochondrion.*| chloroplast.*", "", sp$organism[1]),
    group = sp$group[1],
    organelle = sp$organelle[1],
    length_kb = round(sum(sp$slen) / 1000, 1),
    gc_percent = round(100 * gc / acgt, 1),
    protein_genes = if (any_cds) length(unique(unlist(lapply(k, `[[`, "cds")))) else NA,
    trna_genes = if (any_trna) length(unique(unlist(lapply(k, `[[`, "trna")))) else NA,
    note = note
  )
}
genomes <- do.call(rbind, rows)
genomes <- genomes[order(match(paste(genomes$group, genomes$organelle),
                               paste(groups$group, groups$organelle)), genomes$organism), ]

# Save ####
library(openxlsx)
wb <- createWorkbook()
addWorksheet(wb, "genomes")
writeData(wb, "genomes", paste("Source: NCBI RefSeq, downloaded", download_date), startRow = 1)
writeData(wb, "genomes", genomes, startRow = 2, keepNA = TRUE, na.string = "NA")
saveWorkbook(wb, "data/organelle_genomes.xlsx", overwrite = TRUE)

# Gene map of the human mitogenome (NC_012920.1) for the dataset slide ####
human <- parse_gb(fetch_gb("NC_012920.1")[[1]])
map <- list()
for (f in human$feats) {
  if (!f$key %in% c("CDS", "rRNA", "tRNA")) next
  pos <- as.numeric(regmatches(f$loc, gregexpr("[0-9]+", f$loc))[[1]])
  map[[length(map) + 1]] <- data.frame(
    gene = qual(f, "gene"), type = f$key,
    start = min(pos), end = max(pos),
    strand = ifelse(grepl("complement", f$loc), "-", "+")
  )
}
map <- do.call(rbind, map)
map$type <- c(CDS = "protein-coding", rRNA = "rRNA", tRNA = "tRNA")[map$type]
map <- map[!duplicated(map[, c("gene", "type", "start")]), ]
write.csv(map, "data/mito_map_human.csv", row.names = FALSE)
