# Molecular Approaches to Biodiversity and Ecology
# Introduction to R -- 2026-10-30
# Fill in the ___ blanks in the "Your turn" parts.
# Run inside the course project (open moldiveco.Rproj first), so that "data/genes.csv" is found.

# Run once if the packages are not installed yet:
# install.packages("tidyverse")


# Getting started with R ####

## How to get help ####
# help("setwd")

## Type code with English input ####
# c（2，4，6） # full-width: Error: unexpected input
# c(2, 4, 6) # half-width: works

## R as a calculator ####
2+2
1024/2
1:10
34*4
2^4
sqrt(27)

## Variables ####
var_1 <- 1024 / 2
1238 * 3 -> var_2
var_2

## Vectors ####
23
sqrt(25)

## Some ways to create vectors ####
1:10 # from 1 to 10
-5:3 # from -5 to 3
seq(from = 1, to = 5, by = 0.5)
# ?c # read the help page for this function
c(2, 4, 6)
c(-9.3, 0, 2.17, 21.3)
vect_num <- -11:12 # numeric vector from -11 to 12, stored in vect_num

## Indexing vectors ####
vect_num[1] # the first element of vect_num
vect_num[10] # the 10th element
vect_num[22]
3:5
vect_num[3:5]

## Selecting elements from a vector ####
vect_num[c(2, 4, 6)] # returns the 2nd, 4th and 6th elements
vect_num[c(1, 10, 20)] # returns the 1st, 10th and 20th elements

## Why does this give an error? ####
# vect_num[1, 3, 5]
vect_num[c(1, 3, 5)] # correct

## Combining vectors ####
c(1, 1, 5:9)
c(vect_num, vect_num)
c(100, vect_num)
vect_num[c(1, 3, 5, 22:24)]

## Your turn 1 ####
read_lengths <- c(150, 148, 151, 90, 150, 149, 75, 150)
# 1. Get the 2nd and the 4th read lengths.
# 2. Get the last element, using `length()` instead of typing 8.
# 3. Make a vector `all_reads` that combines `read_lengths` with two more reads, 120 and 151 bp. How many elements does it have?
read_lengths[c(___, ___)]
read_lengths[___(read_lengths)]
all_reads <- ___(read_lengths, 120, 151)
___(all_reads)


# Data types in R ####

## Numeric data ####
class(1:10)
class(2.17)
class(5)

## Character data ####
"this is text"
'this is text, too'
dna_seq <- c("A", "T", "G", "C", "T", "A") # a short DNA fragment
dna_seq # the whole vector

## Selecting from a character vector ####
dna_seq[c(1, 6)]
double_seq <- c(dna_seq, dna_seq)
double_seq
double_seq[5:10] # elements 5 to 10

## Logical data ####
TRUE # true
FALSE # false
c(T, T, T, T, F, F, T, T)
c(TRUE, TRUE, TRUE, FALSE, FALSE, TRUE)
short_logical_vector <- c(FALSE, TRUE)

## A vector holds one data type ####
c(1, "A") # a number and text: everything becomes text
class(c(1, "A"))
c(1, TRUE) # a number and a logical: TRUE becomes 1
class(c(1, TRUE))

## Long vectors ####
rep(x = 1, times = 3) # 1 is repeated 3 times
rep(x = "A", times = 5) # "A" is repeated 5 times (a poly-A tail!)
rep(x = TRUE, times = 2) # TRUE is repeated 2 times

## What is a function? ####
rep(x = "A", times = 5) # function rep(), arguments x and times

## Function arguments ####
rep(TRUE, 5) # TRUE repeated 5 times, arguments without names
vect_log <- c(rep(TRUE, 3), rep(FALSE, 3), rep(TRUE, 4))
vect_log

## Using logical vectors to filter data ####
double_seq

## Example 1 ####
f_g <- double_seq == "G"
f_g
double_seq[f_g]

## Example 2 ####
f_c <- double_seq == "C"
f_g | f_c
double_seq[f_g | f_c]

## A shorter way to write it ####
double_seq[double_seq == "G" | double_seq == "C"]
f_gc <- double_seq == "G" | double_seq == "C"
double_seq[f_gc]

## The same filter in the tidyverse ####
library(dplyr) # part of the tidyverse
filter(data.frame(base = double_seq), base %in% c("G", "C"))

## GC content from a logical vector ####
f_gc
sum(f_gc) # number of G and C bases
mean(f_gc) # GC content: the proportion of G and C, 4 of 12 bases
f_gc2 <- double_seq %in% c("G", "C")
mean(f_gc2)

## Example 3 ####
vect_num
vect_num[vect_num > 0]

## Example 4 ####
f_min8_plus8 <- (vect_num <= -8) | (vect_num >= 8)
vect_num[f_min8_plus8]

## Your turn 2 ####
# 1. Get the reads shorter than 100 bp.
# 2. How many reads are exactly 150 bp long? (Hint: `TRUE` counts as 1.)
# 3. What proportion of the reads are at least 148 bp long?
read_lengths[read_lengths ___ 100]
___(read_lengths == 150)
mean(read_lengths >= ___)

## Factors ####
snp_genotypes <- c("AG", "AA", "AA", "AA", "GG", "GG", "GG", "GG")
snp_genotypes # this is a character vector

## Creating a factor ####
factor(snp_genotypes)
double_seq # character vector
f_double_seq <- factor(double_seq)

## What kind of data is stored in a variable? ####
class(f_double_seq)
class(vect_log)
class(vect_num)
class(dna_seq)

## Built-in constants in R ####
dna_seq_1 <- c("A", "T", NA, "C", "T", "A") # NA: 3rd base not read
length(NULL) # NULL: nothing, so no elements
0 / 0 # NaN
1 / 0 # Inf

## An element that does not exist ####
dna_seq_1[198]

## Arithmetic with vectors ####
vect_num

vect_num + 2
vect_num * 2
vect_num * (-2)
vect_num^2
c(1, 2, 3) + c(10, 20, 30)

## Operations on vectors with constants ####
counts_na <- c(1, 3, NA, 7, 0, 22:24)
counts_na + 2 # NA stays NA
counts_na * 0 # NA stays NA
counts_na / 0  # NA stays NA
sqrt(-1)

## Functions in R ####
counts_na
length(counts_na)
sum(counts_na)

## Functions and vectors with constants ####
sum(counts_na, na.rm = TRUE)
mean(counts_na, na.rm = TRUE)
max(counts_na, na.rm = TRUE) # the largest value
min(counts_na, na.rm = TRUE) # the smallest value

## User-defined functions ####
mmean <- function(x){
  mean(x, na.rm = TRUE)
  }

## Return in the function body ####
mmean <- function(x){
  res <- mean(x, na.rm = TRUE)
  return(res)
}
mean(counts_na) # without na.rm: NA
mean(counts_na, na.rm = TRUE)
mmean(counts_na) # our function ignores NA by default

## Matrices ####
counts <- matrix(c(1520, 980, 12, 1385, 1043, 30, 1610, 875, 7),
                 nrow = 3, ncol = 3)
rownames(counts) <- c("ACTB", "GAPDH", "MYC")
colnames(counts) <- c("sample_1", "sample_2", "sample_3")
counts
rownames(counts)
colnames(counts)

## Lists ####
my_list <- list(
  12:16,
  snp_genotypes,
  c(TRUE, TRUE, TRUE, FALSE, FALSE, TRUE)
)

str(my_list)

## Data frames: two-dimensional data structures ####
ids <- c("gene01", "gene02", "gene03", "gene04", "gene05",
         "gene06", "gene07", "gene08", "gene09") # character: gene IDs
exons <- c(9, 5, 1, 14, 8, 4, 3, 21, 11) # numeric: number of exons
strand <- c("+", "-", "-", "+", "+", "-", "+", "-", "-") # character: strand
# numeric: gene length, bp
len_bp <- c(5230, 18740, 960, 9410, 61200, 2870, 13350, 27600, 7980)

## Creating a data frame ####
my_genes <- data.frame(gene_id = ids, n_exons = exons, length_bp = len_bp,
                       strand = strand)
class(my_genes) # check that it is really a data frame

## Converting other objects to a data frame ####
counts_data <- as.data.frame(counts)
str(counts_data)

## Looking at a data frame ####
my_genes # print the data frame
head(my_genes)
tail(my_genes)
# View(my_genes) # spreadsheet view in RStudio
# fix(my_genes) # manual editing: avoid it, it leaves no record
nrow(my_genes)
ncol(my_genes)
length(my_genes) # gives the number of columns

## Indexing in data frames ####
my_genes$n_exons
my_genes$length_bp
my_genes[2, 3] # 2nd row, 3rd column
my_genes[2, ] # the whole 2nd row
my_genes[1:9, 2] # rows 1 to 9 of the 2nd column
my_genes[, 2] # the whole 2nd column

## Expanding a data frame ####
my_genes$chrom <- c("chr1", "chr1", "chr2", "chr3", "chr2",
                    "chr3", "chrX", "chr2", "chr3")
my_genes

## Adding a row ####
my_genes_new <- data.frame(gene_id = "gene10", n_exons = 5,
                           length_bp = 1840, strand = "+", chrom = "chr1")
my_genes_final <- rbind(my_genes, my_genes_new)
my_genes_final

## Your turn 3 ####
# 1. Get the strand of the 5th gene in two ways: with `$` and with `[row, column]`.
# 2. Get the IDs of all genes on the minus strand (`"-"`).
# 3. Get rows 2 to 4 of the columns `gene_id` and `length_bp` (columns 1 and 3).
my_genes$___[5]
my_genes[___, ___]
my_genes$gene_id[my_genes$strand ___ "-"]
my_genes[___, c(___, ___)]

## Tibbles ####
library(tibble)
my_tibble <- tibble(gene_id = ids, n_exons = exons,
                    length_bp = len_bp, strand = strand)
str(my_tibble)
my_tibble2 <- tibble(gene_id = ids, length_bp = len_bp,
                     length_kb = length_bp / 1000, strand = strand)
my_tibble2


# Reading and writing data ####

## Reading a CSV file ####
genes <- read.csv("data/genes.csv")
head(genes)

## Checking what you have read ####
str(genes)

## Writing a CSV file ####
long_genes <- genes[genes$length_bp > 20000, ]
long_genes
# write.csv(long_genes, "data/long_genes.csv", row.names = FALSE)


# A first look at the data ####

## Quick-look plots in base R ####
hist(genes$length_bp)
plot(x = genes$length_bp,
     y = genes$n_exons)

