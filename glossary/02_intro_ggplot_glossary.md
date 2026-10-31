# Glossary for Nov 2: Introduction to ggplot2 + descriptive statistics I

Publish in Moodle before the lecture. Add each entry to the course Glossary (Concept = term, Definition = text).
Terms are in the order they appear in the slides; each one is in **bold** on its first slide.
Terms from Oct 30 that come up again (NA, factor, data frame, package, tidyverse) keep their Oct 30 wording and are not repeated here.
Chinese terms: only for established statistical, mathematical or biological terms, provided by the instructor; all other terms: `—`.
The "Key terms" slide of `02_intro_ggplot.qmd` is generated from this table: keep the column layout.

| Term | Definition | Chinese term |
| --- | --- | --- |
| Tidy data | A data table in which each column is one variable, each row is one observation and each cell holds one value. Tidy tables are easy to analyse in R. | — |
| Read count | The number of sequencing reads that map to a gene in one sample. More reads means more expression of the gene. | — |
| Wide format | A table layout in which one row holds several measurements of the same variable, in separate columns, e.g. one row per gene and one column of read counts per sample. | — |
| Long format | A table layout with one measurement per row, e.g. one row for each gene in each sample. Most R functions, including `ggplot2`, need data in long format. | — |
| Aesthetic | In `ggplot2`, a visual property of the plot that shows a variable from the data: position on the x or y axis, color, shape, size. You set aesthetics inside `aes()`. | — |
| Geom | In `ggplot2`, the type of geometric object that draws the data: points (`geom_point()`), bars, lines, boxes. | — |
| Scatterplot | A plot that shows two numeric variables as points: one variable on the x axis, the other on the y axis. Each point is one observation. | 散点图 |
| Logarithm (log10) | The power to which 10 must be raised to get a number: 10² = 100, so log10(100) = 2. Each step of 1 on the log10 scale means "10 times more". | 对数 |
| Logarithmic scale | An axis on which each step multiplies the value by the same number (e.g. 10, 100, 1000) instead of adding to it. It shows small and very large values on one plot. | — |
| Facet | In `ggplot2`, one small panel of a plot that shows only one group of the data. Facets put the groups side by side with the same axes. | — |
| Histogram | A plot that shows how often values fall into intervals (bins) of a numeric variable. The height of each bar is the number of observations in the bin. | 直方图 |
| Population | All the objects you want to draw conclusions about, e.g. all mitochondrial genomes of insects. Usually it is too large to measure completely. | — |
| Sample | The objects you have actually measured, chosen from the population, e.g. 25 insect mitochondrial genomes. | — |
| Descriptive statistics | Numbers that summarise a sample, e.g. the median or the range. They describe the data you have; they do not test anything. | — |
| Median | The middle value of the sorted data: half of the values are smaller, half are larger. With an even number of values, it is the mean of the two middle values. | 中位数 |
| Outlier | A value that is far away from most other values. It can be a real extreme value or an error, so check it before you decide what to do with it. | 离群值 |
| Quantile | A value that splits the sorted data into parts with the same number of values in each. The median, the quartiles and the percentiles are quantiles. | 分位数 |
| Quartile | One of the three values that split the sorted data into four equal parts: 25% of the values are below the first quartile (Q1), 50% below the second (the median), 75% below the third (Q3). | 四分位数 |
| Five-number summary | A short description of a sample with five numbers: minimum, first quartile, median, third quartile, maximum. | — |
| Interquartile range (IQR) | The difference between the third and the first quartile, Q3 − Q1. It is the range of the middle 50% of the values. | 四分位距 |
| Boxplot | A plot of the five-number summary: the box goes from Q1 to Q3, the line inside is the median, the whiskers show the rest of the data, and outliers are drawn as separate points. | 箱形图 |
| Pipe | The operator `%>%`: it passes the result on its left into the function on its right, so `x %>% f()` is the same as `f(x)`. Read it as "and then". | — |
