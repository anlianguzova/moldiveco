# Molecular Approaches to Biodiversity and Ecology
# Introduction to ggplot2. Descriptive statistics I -- 2026-11-02
# With answers: full code from the slides, including the "Your turn" tasks.
# Run inside the course project (open moldiveco.Rproj first), so that "data/genes.csv" is found.

# Run once if the packages are not installed yet:
# install.packages(c("tidyverse", "readxl"))


# Wide and long format ####

## Spreadsheets: what not to do (values) ####
counts <- matrix(c(1520, 980, 12, 1385, 1043, 30, 1610, 875, 7),
                 nrow = 3, ncol = 3)
rownames(counts) <- c("ACTB", "GAPDH", "MYC")
colnames(counts) <- c("sample_1", "sample_2", "sample_3")
counts_wide <- data.frame(gene = rownames(counts), counts)
counts_wide

## pivot_longer(): the long table ####
library(tidyr)
counts_long <- pivot_longer(counts_wide, cols = -gene,
                            names_to = "sample", values_to = "count")
counts_long

## Your turn 1 ####
heat_counts <- data.frame(gene = c("ACTB", "GAPDH", "HSPA1A"),
                          ctrl_1 = c(1490, 1012, 38),
                          ctrl_2 = c(1532, 968, 45),
                          heat_1 = c(1475, 1001, 1842),
                          heat_2 = c(1508, 990, 2115))
# 1. Turn `heat_counts` into a long table `heat_long` with the columns `gene`, `sample` and `count`.
# 2. How many rows does `heat_long` have, and why?
heat_long <- pivot_longer(heat_counts, cols = -gene,
                          names_to = "sample", values_to = "count")
heat_long
nrow(heat_long)  # 3 genes x 4 samples = 12


# Our data: organelle genomes ####

## Reading an Excel sheet ####
library(readxl)
genomes <- read_excel("data/organelle_genomes.xlsx",
                      sheet = "genomes", # sheet name
                      skip = 1,          # skip the "Source" row
                      na = "NA")         # code for missing values

## Checking the data ####
str(genomes)
genomes$group <- factor(genomes$group)
genomes$organelle <- factor(genomes$organelle)

## Unusual records: the note column ####
genomes[!is.na(genomes$note), c("organism", "note")]

## Missing values: counting them ####
sum(is.na(genomes$trna_genes))
summary(genomes[, c("length_kb", "gc_percent", "protein_genes", "trna_genes")])

## Missing values: which rows? ####
nrow(genomes[!complete.cases(genomes), ])
num_cols <- c("length_kb", "gc_percent", "protein_genes", "trna_genes")
genomes[!complete.cases(genomes[, num_cols]), c("organism", "protein_genes", "trna_genes")]

## NA is not 0 ####
cnid <- genomes[genomes$group == "cnidarians", ]
mean(cnid$trna_genes, na.rm = TRUE)  # NA left out
trna_zero <- cnid$trna_genes
trna_zero[is.na(trna_zero)] <- 0     # wrong: NA written as 0
mean(trna_zero)


# Plots with ggplot2 ####

## Last time: quick-look plots in base R ####
genes <- read.csv("data/genes.csv")
hist(genes$length_bp)
plot(x = genes$length_bp,
     y = genes$n_exons)

## The same plots with ggplot2 ####
library(ggplot2)
ggplot(data = genes,
       aes(x = length_bp)) +
  geom_histogram(bins = 5)
ggplot(data = genes,
       aes(x = length_bp,
           y = n_exons)) +
  geom_point()

## A first scatterplot ####
ggplot(data = genomes, aes(x = length_kb, y = gc_percent)) +
  geom_point()

## Logarithms ####
10^2
log10(c(10, 100, 1000))
log10(c(16, 160, 1600))  # each 10 times longer: +1

## Why a logarithmic scale? ####
ggplot(data = genomes, aes(x = length_kb, y = gc_percent)) +
  geom_point() +
  scale_x_log10()

## Transform the data or the axis? ####
ggplot(genomes,
       aes(x = log10(length_kb),
           y = gc_percent)) +
  geom_point()
ggplot(genomes,
       aes(x = length_kb,
           y = gc_percent)) +
  geom_point() +
  scale_x_log10()

## Themes ####
ggplot(data = genomes, aes(x = length_kb, y = gc_percent)) +
  geom_point() +
  scale_x_log10() +
  theme_classic()
theme_set(theme_bw(base_size = 14))

## Axis labels and title ####
ggplot(data = genomes, aes(x = length_kb, y = gc_percent)) +
  geom_point() +
  scale_x_log10() +
  labs(x = "Genome length, kb (log scale)", y = "GC content, %",
       title = "Organelle genomes:\nlength and GC content") +
  theme(plot.title = element_text(hjust = 0.5))  # center the title

## Point size, color and shape ####
ggplot(genomes, aes(x = length_kb,
                    y = gc_percent)) +
  geom_point(size = 1,
             color = "blue") +
  scale_x_log10()
ggplot(genomes, aes(x = length_kb,
                    y = gc_percent)) +
  geom_point(shape = 22, size = 2,
             color = "red",
             fill = "yellow") +
  scale_x_log10()

## A plot as an object; saving a plot ####
gc_plot <- ggplot(genomes, aes(x = length_kb, y = gc_percent)) +
  geom_point() +
  scale_x_log10()
gc_plot <- gc_plot + labs(x = "Genome length, kb (log scale)", y = "GC content, %")
# ggsave("gc_plot.png", plot = gc_plot, width = 15, height = 10, units = "cm", dpi = 300)
# ggsave("gc_plot.pdf", plot = gc_plot, width = 15, height = 10, units = "cm")

## Your turn 2 ####
# 1. Draw a scatterplot of the number of protein-coding genes (y) against genome length (x), with genome length on a logarithmic scale.
# 2. Label the axes "Genome length, kb (log scale)" and "Protein-coding genes".
# 3. Use `theme_classic()` and points of size 2.
# 4. Save the plot as `protein_genes.png`, 15 × 10 cm.
prot_plot <- ggplot(genomes, aes(x = length_kb, y = protein_genes)) +
  geom_point(size = 2) +
  scale_x_log10() +
  labs(x = "Genome length, kb (log scale)", y = "Protein-coding genes") +
  theme_classic()
prot_plot
# ggsave("protein_genes.png", plot = prot_plot, width = 15, height = 10, units = "cm")


# Aesthetics ####

## Mapping a variable to color ####
ggplot(genomes, aes(x = length_kb, y = gc_percent, color = organelle)) +
  geom_point() +
  scale_x_log10()

## Overlapping points ####
ggplot(genomes, aes(x = length_kb,
                    y = gc_percent,
                    color = organelle)) +
  geom_point(size = 3) +
  scale_x_log10()
ggplot(genomes, aes(x = length_kb,
                    y = gc_percent,
                    fill = organelle)) +
  geom_point(shape = 21,
             color = "black",
             size = 2, alpha = 0.6) +
  scale_x_log10()

## Choosing your own colors ####
org_plot <- ggplot(genomes, aes(x = length_kb, y = gc_percent,
                                fill = organelle)) +
  geom_point(shape = 21, color = "black", size = 2, alpha = 0.6) +
  scale_x_log10() +
  scale_fill_manual(values = c("darkorange", "forestgreen"))
org_plot

## Legend position ####
org_plot +
  theme(legend.position = "bottom")
org_plot +
  theme(legend.position = "inside",
        legend.position.inside = c(0.85, 0.2))

## Two variables: fill and shape ####
ggplot(genomes, aes(x = length_kb, y = gc_percent,
                    fill = group, shape = organelle)) +
  geom_point(color = "black", size = 2, alpha = 0.7) +
  scale_shape_manual(values = c(21, 24)) +
  scale_x_log10()

## Comparing organisms: mitochondria only ####
mito <- genomes[genomes$organelle == "mitochondrion", ]
nrow(mito)

## Facets ####
ggplot(mito, aes(x = length_kb, y = gc_percent)) +
  geom_point(shape = 21, color = "black", fill = "grey60",
             size = 2, alpha = 0.6) +
  scale_x_log10() +
  facet_wrap(~ group)

## Facets in a grid ####
ggplot(genomes, aes(x = length_kb, y = gc_percent)) +
  geom_point(shape = 21, color = "black", fill = "grey60",
             size = 2, alpha = 0.6) +
  scale_x_log10() +
  facet_grid(organelle ~ group)


# Distributions ####

## Histogram ####
ggplot(genomes,
       aes(x = gc_percent)) +
  geom_histogram(binwidth = 5)
ggplot(genomes,
       aes(x = gc_percent)) +
  geom_histogram(binwidth = 1)

## Geoms and stats ####
ggplot(genomes, aes(x = gc_percent)) +
  stat_bin(geom = "line", binwidth = 2, linewidth = 1, color = "red")

## Comparing groups ####
ggplot(mito, aes(
  x = gc_percent)) +
  geom_histogram(
    binwidth = 1) +
  facet_wrap(~ group,
             ncol = 1)

## Density curves ####
ggplot(genomes, aes(x = gc_percent, fill = organelle)) +
  geom_density(alpha = 0.5)

## Group means ####
ggplot(mito, aes(x = group, y = gc_percent, fill = group)) +
  stat_summary(fun = "mean", geom = "bar")

## A trend line ####
ggplot(genomes, aes(x = length_kb, y = protein_genes)) +
  geom_point(shape = 21, color = "black", fill = "grey60",
             size = 2, alpha = 0.6) +
  scale_x_log10() +
  geom_smooth(method = "lm")

## Your turn 3 ####
# 1. Draw GC content (y) against genome length (x, log scale) for all genomes, in the readable style (`shape = 21`, `alpha`), with the fill showing `organelle` and the legend at the bottom. Fill the points with your two favorite colors.
# 2. Draw a histogram of `protein_genes` of the mitochondria (`mito`), with `binwidth = 5` and one facet per `group` in one column.
ggplot(genomes, aes(x = length_kb, y = gc_percent, fill = organelle)) +
  geom_point(shape = 21, color = "black", size = 2, alpha = 0.6) +
  # any two colors work:
  scale_fill_manual(values = c("darkorange", "steelblue")) +
  scale_x_log10() +
  theme(legend.position = "bottom")
ggplot(mito, aes(
  x = protein_genes)) +
  geom_histogram(
    binwidth = 5) +
  facet_wrap(~ group,
             ncol = 1)


# Describing a sample ####

## Median ####
insects <- mito[mito$group == "insects", ]
sizes <- head(insects$length_kb, 8)
sizes
sort(sizes)
median(sizes)

## The median is robust to outliers ####
sizes2 <- c(sizes, 1684.6)
median(sizes)
median(sizes2)
mean(sizes)
mean(sizes2)

## Quantiles ####
quantile(insects$length_kb, probs = c(0.25, 0.5, 0.75))
quantile(insects$length_kb, probs = c(0.1, 0.9))

## Five-number summary ####
quantile(insects$length_kb)

## A boxplot in ggplot2 ####
ggplot(insects, aes(x = "insects", y = length_kb)) +
  geom_boxplot() +
  labs(x = NULL, y = "Genome length, kb")

## Summaries by group with the pipe ####
library(dplyr)

## Summaries by group: a first example ####
genomes %>%
  group_by(group, organelle) %>%
  summarise(n = n(), median_length = round(median(length_kb)))

## Boxplots by group ####
ggplot(mito, aes(x = group, y = gc_percent)) +
  geom_boxplot() +
  labs(x = NULL, y = "GC content, %")

## Your turn 4 ####
# 1. Draw boxplots of the number of tRNA genes (`trna_genes`) for each `group` of mitochondria (`mito`).
# 2. Which group has a point far above its box?
# 3. Calculate the five-number summary of `trna_genes` for each group with `%>%`, `group_by()` and `summarise()`: minimum, Q1, median, Q3, maximum. Use `na.rm = TRUE`.
# 4. Which group has the largest interquartile range?
ggplot(mito, aes(x = group, y = trna_genes)) +
  geom_boxplot()
mito %>%
  group_by(group) %>%
  summarise(min = min(trna_genes, na.rm = TRUE),
            Q1 = quantile(trna_genes, 0.25, na.rm = TRUE),
            median = median(trna_genes, na.rm = TRUE),
            Q3 = quantile(trna_genes, 0.75, na.rm = TRUE),
            max = max(trna_genes, na.rm = TRUE))

## An outlier: biology or error? ####
cnid[cnid$trna_genes > 2 & !is.na(cnid$trna_genes), c("organism", "accession", "trna_genes")]

