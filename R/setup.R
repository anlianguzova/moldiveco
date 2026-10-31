# Shared setup for all decks. Sourced from the setup chunk of every NN_topic.qmd.

knitr::opts_chunk$set(dev = "ragg_png", dpi = 300, fig.align = "center",
                      message = FALSE, warning = FALSE,
                      collapse = TRUE)  # code and its output in one block saves slide space
options(width = 70)  # printed output fits the slide width

# Figure size presets: use `#| opts.label: "M"` in a chunk
knitr::opts_template$set(
  S    = list(fig.width = 4, fig.height = 3),    # small, e.g. inside a column
  M    = list(fig.width = 6, fig.height = 4),    # default single plot
  L    = list(fig.width = 8, fig.height = 5),    # full slide
  wide = list(fig.width = 9, fig.height = 3.5)   # wide and short, e.g. under text
)

library(ggplot2)
theme_set(theme_bw(base_size = 14) + theme(legend.key = element_blank()))
update_geom_defaults("point", list(shape = 19, size = 2))  # size 3 made points overlap

# Glossary of a session as a data frame: term, definition, chinese
read_glossary <- function(file) {
  lines <- readLines(file, encoding = "UTF-8")
  rows <- grep("^\\|", lines, value = TRUE)[-(1:2)]  # drop header and |---| line
  cells <- lapply(rows, function(r) {
    x <- strsplit(sub("^\\|\\s*", "", sub("\\s*\\|\\s*$", "", r)), "\\s*(?<!\\\\)\\|\\s*", perl = TRUE)[[1]]
    setNames(x[1:3], c("term", "definition", "chinese"))
  })
  as.data.frame(do.call(rbind, cells))
}

# Chinese text as raw LaTeX in the CJK font. XeTeX code points (^^^^4e2d), so the
# slide is right whatever the R locale
cjk_latex <- function(x) {
  codes <- paste0("^^^^", sprintf("%04x", utf8ToInt(enc2utf8(x))), collapse = "")
  paste0("`{\\cjkfont ", codes, "}`{=latex}")
}

# Chinese term of a glossary entry, for inline use on a slide:
#   **median** (`r zh("glossary/02_intro_ggplot_glossary.md", "Median")`)
zh <- function(file, term) {
  gl <- read_glossary(file)
  x <- gl$chinese[gl$term == term]
  if (length(x) != 1 || x %in% c("", "\u2014")) stop("No Chinese term for ", term, " in ", file)
  cjk_latex(x)
}

# "Key terms" slide, generated from the session glossary so the two never drift apart.
# Use in a chunk with `#| results: asis`:
#   key_terms("glossary/02_intro_ggplot_glossary.md", c("Median", "Boxplot"))
# The Chinese term, if the glossary has one (not "—"), is shown next to the English term.
key_terms <- function(file, terms) {
  gl <- read_glossary(file)
  missing <- setdiff(terms, gl$term)
  if (length(missing) > 0) stop("Not in ", file, ": ", paste(missing, collapse = ", "))
  gl <- gl[match(terms, gl$term), ]
  has_zh <- !is.na(gl$chinese) & !gl$chinese %in% c("", "\u2014")  # \u2014: the dash "—"
  term <- ifelse(has_zh,
                 paste0("**", gl$term, "** ", vapply(gl$chinese, cjk_latex, "")),
                 paste0("**", gl$term, "**"))
  out <- c("| Term | Meaning |", "|:---------|:--------------------------------|",
           paste0("| ", term, " | ", gl$definition, " |"))
  cat(out, sep = "\n")
}

# Placeholder for a screenshot that will be pasted in later.
# Creates a grey PNG at `path` only if no file exists there yet, so dropping the
# real screenshot at the same path replaces the placeholder on the next render.
screenshot_placeholder <- function(path, what) {
  if (!file.exists(path)) {
    dir.create(dirname(path), showWarnings = FALSE, recursive = TRUE)
    ragg::agg_png(path, width = 1600, height = 1000, res = 150)
    grid::grid.rect(gp = grid::gpar(fill = "grey92", col = "grey50", lty = 2, lwd = 4))
    grid::grid.text(paste0("SCREENSHOT PLACEHOLDER\n\n", what, "\n\n", path),
                    gp = grid::gpar(col = "grey30", fontsize = 18))
    grDevices::dev.off()
  }
  knitr::include_graphics(path)
}
