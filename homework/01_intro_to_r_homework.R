# Homework 1: Introduction to R (Oct 30), optional tasks
# Your name:
# Use only the operators and functions from the lecture (exception: toupper() for the bonus in Task 1*).

# Data: 8 genes, the same as in the quiz (made-up values)
gene_id    <- c("gene01", "gene02", "gene03", "gene04", "gene05", "gene06", "gene07", "gene08")
length_bp  <- c(1250, 830, 2410, 1720, 960, 3050, 1480, 640)
gc_content <- c(0.52, 0.47, 0.61, NA, 0.44, 0.58, 0.50, 0.39)
chrom      <- c("chr1", "chr2", "chr1", "chr3", "chr2", "chr1", "chr3", "chr2")
expressed  <- c(TRUE, FALSE, TRUE, TRUE, FALSE, TRUE, TRUE, FALSE)
genes <- data.frame(gene_id, length_bp, gc_content, chrom, expressed)


## Task 1*. Function gc_fraction(): the proportion of G and C in a vector of DNA bases ####
# Test vector (expected result 0.625): c("A", "G", "G", "C", "T", "A", "C", "G")
# Make it also work for lowercase bases, e.g. c("a", "g", "c") (see ?toupper).



## Task 2*. Summary of `genes` in 3–4 sentences, as comments ####
# Include: the number of genes, the number and proportion of expressed genes,
# the longest gene, and the mean length of the genes that are NOT expressed.
# Calculate every number in code.


