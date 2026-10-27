# moldiveco — Molecular Approaches to Biodiversity and Ecology

Master's course, Faculty of Biology, Shenzhen MSU-BIT University (autumn 2026 – Jan 2027).
Instructor: Nasta Lianguzova. Students' R/bash/Python backgrounds are unknown in advance — first sessions double as a diagnostic.

## Repo conventions
- Presentations: `.qmd` files in the repo root, one per session.
- Images and other dependencies in subfolders (mirror the structure of the `multivar` source repo).
- Homework/task files: one per date, submitted by students as plain R scripts/text via Moodle (no Quarto/R Markdown reports).
- The instructor reviews and commits all changes herself via GitHub Desktop. Do not commit or push.
- Write menu paths with `->` (e.g. `Tools -> Global Options`), not `→`: the deck font (Corbel) has no → glyph.
- Screenshots: real images from `images/`, each on its own slide after the text slide, with `out-width: "95%"`, `out-height: "86%"` and a one-line caption. Don't use bold for UI terms; bold marks glossary terms.
- Dashes (slides, glossary, homework): where a dash separates a term from its definition (e.g. "`a`: bad", "`NA`: not available"), use a colon. Elsewhere use an unspaced em dash in US style ("word—word"), or rephrase with a comma or colon if that reads better. Never use spaced Russian-style dashes (" — "); in Quarto, `---` renders as an em dash, so the same rule applies to it.

## First task: presentation template
Before any session content, build a reusable presentation template in `moldiveco`, modeled on `multivar/08_PCA_geom_morph.qmd` and its dependencies: YAML header/format, theme and styles, shared setup chunk, folder layout for images and other dependencies. Include an example slide for each common element (title, section, code + output, figure with caption, two columns, image placeholder for a screenshot to be pasted later). All session decks are created from this template.

## Source repos (read-only, never modify)
- `/Users/nastalianguzova/Documents/GitHub/mathmethr` — R intro materials
- `/Users/nastalianguzova/Documents/work/spbu/courses/GitHub/linmodr` — linear models course (R basics, ggplot2, descriptive stats, hypothesis testing, LM, GLM); also at https://polydora.github.io/linmodr/
- `/Users/nastalianguzova/Documents/work/spbu/courses/GitHub/multivar` — multivariate course; `08_PCA_geom_morph.qmd` + its dependencies are the template for presentation format and repo structure

Source materials are in Russian and use ecological examples. Adaptation = reframing for a molecular/bioinformatics audience and swapping example datasets; the statistics itself carries over.

## Schedule (confirmed)
| Date | Slots | Topic |
|---|---|---|
| Oct 30 | 2 | R intro + environment setup |
| Nov 2 | 1 | ggplot2 basics + descriptive statistics |
| Nov 6 | 2 | Hypothesis testing → simple linear regression |
| Nov 9 | 1 | ANOVA (as a linear model with a categorical predictor) |
| Nov 13 | 2 | Intro to GLM + the idea of count data (framed as the model behind DESeq2/edgeR) |
| Nov 16 | 1 | Intro to multivariate data |
| Nov 20 | 2 | nMDS |
| Nov 27 | 2 | PCA |
| Dec 4 | 2 | Clustering & classification + phylogenetics intro (tree visualization) |
| Dec 11 | 2 | Differential expression workflow (DESeq2/edgeR) |
| Dec 18 | 2 | Multiple testing, enrichment, volcano plots / heatmaps |
| Dec 25 | 2 | Genomics overview — tentative, likely dropped if earlier topics are expanded |
| Jan 4 | 1 | Optional/advanced — TBD |
| Jan 8 | 2 | Optional/advanced ×2 — TBD |

2-slot dates = lecture + practical. No capstone project and no buffer day; homework after each date.

Sequencing rules: ggplot2 always before any statistics; regression and ANOVA before GLM (ANOVA taught as a linear model, so GLM = same structure, different error distribution). Core topics may be stretched over more sessions if students need it; the schedule after Nov 13 is provisional.

## Code conventions
- Pipe: use the magrittr/dplyr pipe `%>%` throughout the course. It is introduced on Nov 2 together with `library(tidyverse)`; mention once there that the base-R pipe `|>` does the same.
- Packages: every script starts with one commented-out `install.packages()` line listing all packages it uses; packages from the tidyverse (ggplot2, dplyr, tidyr, readr, purrr, tibble, stringr, forcats, lubridate) are installed as one `"tidyverse"`, other packages are listed separately (e.g. `install.packages(c("tidyverse", "vegan"))`). `library()` loads individual packages (e.g. `library(dplyr)`) and is called only right before the first use of a package (in the deck and the scripts), never all at the top, so students see which functions come from which package.

## Operating systems
Assume students use **Windows**. Write all OS-specific instructions (paths, shortcuts, installation, file locations, terminal commands) for Windows first and in full. Put macOS/Linux differences only in a short note at the end of the relevant section, e.g. "On macOS: Cmd instead of Ctrl; paths use / instead of \".

## China delivery constraints
- Assume slow or blocked access to Western resources: use Chinese CRAN/Bioconductor/conda mirrors, pre-download datasets, pin package versions.
- Keep data small (subsample where needed) so it runs on varied student laptops.

## Language
English for all student-facing materials (slides, homework, glossary, quizzes). Source repos are in Russian: translate and adapt, don't copy Russian text.

## Per-session deliverables (Moodle structure, following colleague V. Ivanenko's proposal)
For each date, produce:
1. **Slides**: `NN_topic.qmd` in the repo root.
2. **Homework**: a Moodle quiz (GIFT file, ~8 auto-graded questions: numerical with tolerance or multiple choice, answers verified in R) plus 1–2 optional tasks marked with `*` (e.g. `Task 1*`), submitted as an `.R` file for bonus points; optional tasks must be checkable from the script's output, not by inspecting files it writes.
   - Optional-task `.R` files are minimal: title, `# Your name:`, the data, and each task as `## Task N*. <short description> ####` with only the information needed to solve it. Submission instructions and points go in the Moodle assignment description, not in the file.
   - When writing homework (quiz and optional tasks), use only what was covered in that session and earlier sessions: operators, functions, arguments and concepts. Before finalizing, check every function the solution needs against the decks. If something is missing, choose one of these and tell the instructor which you chose:
     a) don't use it: rewrite the task so it can be solved with covered material;
     b) use it with an explicit note in the task (e.g. "new function: toupper(), see ?toupper"), only for optional tasks and only if it's easy to look up;
     c) propose adding it to the lecture, if it naturally belongs there (e.g. max() next to sum() and mean()), and wait for the instructor's decision.
     Never use uncovered material silently.
3. **Pre-lecture glossary**: the key terminology for that session, each term with a short plain-English definition, published in Moodle *before* the lecture so students can read it in advance; entries also go into the cumulative Moodle Glossary. Students may not be native English speakers, so keep definitions simple, and flag the terms in bold on the slide where they first appear. Prepare the glossary first, then the slides.
   - The glossary file is the single source of truth. Columns: English term, simple English definition, Chinese term, verification status.
   - Chinese terms: from Nov 2 onward, add the standard Chinese equivalent for statistical and biological terms, marked `unverified`; the instructor checks them against termonline.cn and changes the status to `verified`. R-specific terms (data frame, vector, working directory, function, package) stay English-only. Never present an unverified Chinese term to students as checked.
   - Each deck (from Nov 2) starts with a "Key terms" slide showing 5–8 of that session's terms, generated from the glossary file rather than typed separately, so the two never drift apart.
4. **Quiz questions**: a few multiple-choice questions on terminology and concepts for a Moodle Quiz (auto-graded; no code auto-grading).
5. **Scripts**: two scripts generated from the deck with the helper in `R/` (`source("R/make_scripts.R"); make_scripts("NN_topic.qmd")`): `NN_topic.R` for students ("Your turn" answers as `___` blanks, written in hidden `#| student: true` chunks in the deck) and `NN_topic_answers.R` (full code with answers, runs with `source()`). Scripts contain only runnable code with short one-line comments; headers are `# Section ####` and `## Topic ####`, only for parts with code; full explanations stay in the slides.

### Standard ending slides (every deck)
1. **What we have learned**: 4–6 short bullet points summarizing the session's main ideas in plain English.
2. **Key R functions**: a compact table of the R functions (and important arguments) introduced in the session, with a one-line explanation and a minimal example each (e.g. `mean()` | arithmetic mean of a vector | `mean(x, na.rm = TRUE)`). Only functions actually used in the deck; keep wording consistent with the glossary. Exception: the first deck (`01_intro_to_r`) uses **Key R objects and functions** instead, also covering the object types introduced there (vector, factor, matrix, data frame, list).
Then any homework/next-session slide.

### Session-specific notes
- **Oct 30 (R intro)**: include annotated RStudio screenshots explaining the interface (the four panes, console vs script, environment, files/plots/help, running code, setting the working directory / using projects). Insert them as image placeholders in `images/` with descriptive file names (e.g. `images/rstudio_panes.png`) and a caption saying what the screenshot must show; the instructor captures the actual screenshots.

Keep glossary entries consistent across sessions: reuse the existing wording for a term rather than redefining it.
