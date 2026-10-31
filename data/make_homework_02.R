# Data for the Nov 2 homework (quiz and optional tasks): data/homework_02_enzyme.xlsx.
# Built from the R dataset Puromycin (package datasets): reaction rate of an enzyme
# at different substrate concentrations, in cells treated or untreated with puromycin.
# A few rate values are replaced by NA for the exercise.

library(openxlsx)

enzyme <- data.frame(conc = datasets::Puromycin$conc,
                     rate = datasets::Puromycin$rate,
                     state = as.character(datasets::Puromycin$state))

# NA in 3 cells of rate
set.seed(2)
enzyme$rate[sample(nrow(enzyme), 3)] <- NA

wb <- createWorkbook()
# A first sheet with the column descriptions: without sheet = "enzyme",
# read_excel() reads this one
addWorksheet(wb, "info")
writeData(wb, "info", data.frame(
  column = c("conc", "rate", "state"),
  description = c("substrate concentration, ppm",
                  "reaction rate, counts/min/min",
                  "cells treated or untreated with puromycin")))
addWorksheet(wb, "enzyme")
writeData(wb, "enzyme", paste("Source: Puromycin dataset in R (Treloar 1974; Bates & Watts 1988).",
                              "NA values added for this exercise."), startRow = 1)
writeData(wb, "enzyme", enzyme, startRow = 2, keepNA = TRUE, na.string = "NA")
saveWorkbook(wb, "data/homework_02_enzyme.xlsx", overwrite = TRUE)
