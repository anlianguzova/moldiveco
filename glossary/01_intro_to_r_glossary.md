# Glossary for Oct 30: Introduction to R

Used only to build the deck's Key terms slide (and the Chinese terms on the slides); not published in Moodle.
Terms are in the order they appear in the slides; each one is in **bold** on its first slide.
Later sessions: reuse this wording when a term comes up again.
Chinese terms: only for established statistical, mathematical or biological terms, provided by the instructor; all other terms: `—`.

| Term | Definition | Chinese term |
| --- | --- | --- |
| R | A free programming language and program for statistics, data analysis and graphics. | — |
| RStudio | A program that makes working with R easier. It shows your code, results, objects and plots in one window. | — |
| IDE (integrated development environment) | A program that puts together everything you need to write code: a code editor, a console, a file browser and help. RStudio is an IDE for R. | — |
| Working directory | The folder on your computer where R looks for files to read and where it saves files by default. | — |
| Console | The RStudio pane where R runs commands and immediately shows the result. Code typed in the console is not saved. | — |
| Environment | The RStudio pane that lists all objects you have created in the current R session. | — |
| Script | A text file with R code (file name ends in `.R`). You save it, so you can run the same analysis again later. | — |
| Project (RStudio project) | A course or analysis folder with a `.Rproj` file in it. When you open the `.Rproj` file, RStudio starts with this folder as the working directory. | — |
| File path | The address of a file or folder on your computer, e.g. `C:\Users\student\Documents\moldiveco`. In R code, write Windows paths with `/` or `\\` instead of a single `\`: `"C:/Users/student/Documents/moldiveco"`. | — |
| Relative path | A file path that starts from the working directory, not from the drive, e.g. `"data/genes.csv"`. With an RStudio project, relative paths work on every computer. | — |
| Package | A collection of R functions (and sometimes data) that adds new abilities to R. You install a package once, and load it with `library()` every time you start R. | — |
| CRAN | The main online store of R packages. A CRAN mirror is a copy of CRAN on a server in another country; a nearby mirror downloads faster. | — |
| Comment | Text after the `#` symbol in code. R does not run it; comments explain the code to people. | — |
| Operator | A symbol that does a calculation or a comparison, e.g. `+`, `*`, `^` or `>`. | — |
| Assignment operator | The arrow `<-` that stores a value in a variable: `x <- 5` puts 5 into `x`. | — |
| Variable | A name that stores a value, so you can use the value later, e.g. `x <- 5`. In statistics, "variable" also means a measured characteristic, such as one column in a data table. | — |
| Object | Anything stored in R under a name: a number, a vector, a table, a function. | — |
| Vector | The basic data object in R: an ordered set of one or more values, all of the same type, e.g. `c(2, 4, 6)`. A single number is a vector of length 1. | — |
| Function | A named command that takes inputs (arguments), does something with them and returns a result. You call it by its name with round brackets: `sqrt(9)`. | — |
| Argument | An input value given to a function inside its brackets, written `name = value` and separated by commas, e.g. `times = 3` in `rep(x = 1, times = 3)`. Some arguments have default values, so you can leave them out. | — |
| Index | The position number of an element in a vector. Indexing means selecting elements by position with square brackets: `x[3]` is the third element. | — |
| Data type | The kind of values an object holds. The basic types are numeric (numbers), character (text) and logical (`TRUE`/`FALSE`). | — |
| Numeric | The data type for numbers, e.g. `3`, `-0.5`, `1e6`. R stores numbers either as integers or as doubles. | — |
| Integer | Numbers stored as whole numbers, e.g. the numbers made by `1:10`. `class()` shows them as `"integer"`. | — |
| Double | Numbers stored so that they can have a decimal part, e.g. `2.17`. Every number you type, even `5`, is stored as a double; `class()` shows it as `"numeric"`. | — |
| Character (string) | The data type for text. Each text value is written in quotation marks, e.g. a DNA base: `"G"`. | — |
| Logical | The data type with only two values: `TRUE` (true) and `FALSE` (false). In calculations, `TRUE` counts as 1 and `FALSE` as 0. | — |
| Logical operator | A symbol that compares values or combines conditions and returns `TRUE` or `FALSE`: `==` (equal), `!=` (not equal), `<`, `>`, `<=`, `>=`, `&` (and), `\|` (or), `!` (not). | — |
| Filtering | Keeping only the elements that meet a condition, by putting a logical vector inside square brackets, e.g. `dna_seq[dna_seq == "G"]` keeps only the G bases. | — |
| Tidyverse | A collection of R packages for data work that share the same style, e.g. `tibble`, `dplyr` and `ggplot2`. We use it from Nov 2. | — |
| Categorical variable | A variable whose values are categories (groups), not measurements, e.g. genotype (AA, AG, GG) or DNA strand (+, −). | — |
| Factor | The R object for a categorical variable. Each value is one of a fixed set of categories, called levels. Statistical models use factors to compare groups. | — |
| Level | One of the possible categories of a factor. By default R sorts levels alphabetically. | — |
| NA | "Not available": a missing value. The observation exists, but its value was not measured or recorded. | — |
| NULL | Empty: there is no object at all. `length(NULL)` is 0. | — |
| NaN | "Not a number": the result of a calculation that has no answer, e.g. `0 / 0` or `sqrt(-1)`. | — |
| Inf | Infinity, e.g. the result of `1 / 0`. | — |
| User-defined function | A function that you write yourself with `function()`, to repeat the same steps without copying code. | — |
| Matrix | A two-dimensional table of values of one type, with rows and columns, e.g. read counts with genes in rows and samples in columns. | — |
| Housekeeping gene | A gene needed for basic functions in almost every cell, so it is expressed at a high and stable level, e.g. *ACTB* (beta-actin) or *GAPDH*. | — |
| List | An object that can hold elements of different types and lengths, e.g. a number, a text vector and a table together. | — |
| Data frame | The usual R object for a data table. Each column is a vector (one variable); all columns have the same length; different columns can have different types. Each row is one observation. | — |
| Tibble | A modern version of a data frame from the `tibble` package. It works almost the same, but prints more neatly. | — |
| CSV file | A plain-text table file (name ends in `.csv`): one row per line, values separated by commas. R, Excel and most other programs can read and write it. | — |
