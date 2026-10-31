# A deliberately messy spreadsheet for the "Tidy data" slides of 02_intro_ggplot.qmd
# (made-up values). Open data/messy_sheet_example.xlsx in Excel for the screenshot;
# students can also look for the problems themselves.
# Problems built in: a title row, two header rows, merged cells, groups coded only
# by cell color, units typed next to numbers, two values in one cell, several codes
# for "missing" (empty, "-", 0, "n/a", "no data"), mixed date formats, a total row.

library(openxlsx)
wb <- createWorkbook()
addWorksheet(wb, "Sheet1")

# Title row and two header rows
writeData(wb, "Sheet1", "Mitochondrial sequencing, Daphnia ponds, autumn 2026", startCol = 1, startRow = 1)
writeData(wb, "Sheet1", t(c("Sample", "Collection", "", "Sequencing", "", "", "Notes")),
          startCol = 1, startRow = 2, colNames = FALSE)
writeData(wb, "Sheet1", t(c("", "Date", "Pond", "Reads (M)", "Length", "GC", "")),
          startCol = 1, startRow = 3, colNames = FALSE)

# Data: two replicates per sample, sample ID merged over both rows
rows <- rbind(
  c("D1", "02.11.2026", "Pond A", "12.5 / 13.1", "16.5 kb", "38%", ""),
  c("",   "02.11.2026", "Pond A", "11.8",        "16540",   "0.37", "re-run"),
  c("D2", "Nov 3",      "pond a", "",            "16 540 bp", "37.9", ""),
  c("",   "Nov 3",      "Pond A", "no data",     "n/a",     "-",    "failed?"),
  c("D3", "2026-11-04", "Pond B", "9.6",         "16.6 kb", "38 %", ""),
  c("",   "2026-11-04", "Pond B", "0",           "-",       "",     "contaminated"),
  c("D4", "4/11",       "B",      "10.2",        "16552",   "0.38", ""),
  c("",   "4/11",       "B",      "10,9",        "16.55",   "38.2", "")
)
writeData(wb, "Sheet1", rows, startCol = 1, startRow = 4, colNames = FALSE)
writeData(wb, "Sheet1", t(c("TOTAL", "", "", "54.4", "", "", "")), startCol = 1, startRow = 12, colNames = FALSE)

# Merged cells
mergeCells(wb, "Sheet1", cols = 1:7, rows = 1)
mergeCells(wb, "Sheet1", cols = 1, rows = 2:3)
mergeCells(wb, "Sheet1", cols = 2:3, rows = 2)
mergeCells(wb, "Sheet1", cols = 4:6, rows = 2)
mergeCells(wb, "Sheet1", cols = 7, rows = 2:3)
for (r in c(4, 6, 8, 10)) mergeCells(wb, "Sheet1", cols = 1, rows = r:(r + 1))

# Groups coded only by color: yellow = control ponds, green = treated ponds
addStyle(wb, "Sheet1", createStyle(fgFill = "#FFF2A8"), rows = 4:7, cols = 1:7, gridExpand = TRUE)
addStyle(wb, "Sheet1", createStyle(fgFill = "#C6E9C0"), rows = 8:11, cols = 1:7, gridExpand = TRUE)
addStyle(wb, "Sheet1", createStyle(textDecoration = "bold", halign = "center", valign = "center"),
         rows = 1:3, cols = 1:7, gridExpand = TRUE)
addStyle(wb, "Sheet1", createStyle(textDecoration = "bold"), rows = 12, cols = 1:7, gridExpand = TRUE)
addStyle(wb, "Sheet1", createStyle(valign = "center"), rows = 4:11, cols = 1, gridExpand = TRUE, stack = TRUE)
setColWidths(wb, "Sheet1", cols = 1:7, widths = c(9, 12, 9, 12, 11, 7, 14))

saveWorkbook(wb, "data/messy_sheet_example.xlsx", overwrite = TRUE)
