# Build the two R scripts for a session from its deck.
#
#   source("R/make_scripts.R")
#   make_scripts("01_intro_to_r.qmd")
#
# writes, next to the deck:
#   NN_topic.R          for students: "Your turn" answers come from the
#                       hidden `#| student: true` chunks (with ___ blanks)
#   NN_topic_answers.R  full code with "Your turn" answers; runs with source()
#
# Rules, read from the deck:
# - only code that students would run goes into the scripts: chunks with
#   `purl: false` (screenshots), the setup chunk, comment-only chunks and
#   `eval: false` chunks (code that is only shown, e.g. setwd() examples)
#   are skipped;
# - `eval: false` chunks marked `#| script: "comment"` (help(), View(),
#   write.csv(), the full-width brackets) and `error: true` chunks are
#   included, commented out, so students can try them;
# - deck sections (# ...) become `# Section ####`, slide titles (## ...)
#   become `## Topic ####`, only for parts with code; consecutive slides on the
#   same topic share one header (": in RStudio", "Your turn N: ..." and
#   "answers" suffixes are dropped before comparing, and "X: ..." right after
#   "X" counts as the same topic);
# - chunks under a "Your turn ...: answers" slide are answers: full script only;
# - chunks with `student: true` are blanked answers: student script only
#   (hide them on the slide with `include: false` and `eval: false`);
# - numbered task lines on "Your turn" slides are copied as comments;
# - the header gets one commented-out install.packages() line for all packages
#   loaded with library() in the deck (tidyverse packages as one "tidyverse");
#   library() itself stays where the deck first uses each package.
# Keep code comments in the deck short (one line): they are copied as they are.

make_scripts <- function(qmd) {
  lines <- readLines(qmd, encoding = "UTF-8")

  # YAML header: title and date
  yaml_end <- which(lines == "---")[2]
  yaml <- lines[2:(yaml_end - 1)]
  yaml_value <- function(key) {
    x <- grep(paste0("^", key, ":"), yaml, value = TRUE)
    if (length(x) == 0) return("")
    gsub('^[a-z]+:\\s*"?|"?\\s*$', "", x[1])
  }
  body <- lines[(yaml_end + 1):length(lines)]

  topic_of <- function(title) {
    title <- sub(": in RStudio$", "", title)
    title <- sub("^(Your turn [0-9]+):.*$", "\\1", title)
    sub("\\s*:?\\s*[Aa]nswers?$", "", title)
  }

  # Walk the body: headings, task lines and R chunks, in order
  items <- list()
  title <- ""
  i <- 1
  while (i <= length(body)) {
    line <- body[i]
    if (grepl("^# ", line)) {
      title <- sub("^# ", "", line)
      items[[length(items) + 1]] <- list(type = "section", text = title)
    } else if (grepl("^## ", line)) {
      title <- sub("^## ", "", line)
      items[[length(items) + 1]] <- list(type = "topic", text = topic_of(title))
    } else if (grepl("^```\\{r", line)) {
      end <- i + which(body[(i + 1):length(body)] == "```")[1]
      chunk <- body[(i + 1):(end - 1)]
      opts <- grep("^#\\|", chunk, value = TRUE)
      code <- chunk[!grepl("^#\\|", chunk)]
      has <- function(pattern) any(grepl(pattern, opts))
      student <- has("student:\\s*true")
      show_commented <- has('script:\\s*"?comment"?')
      only_comments <- all(code == "" | grepl("^\\s*#", code))
      skip <- grepl("setup", line) || has("purl:\\s*false") ||
        (has("eval:\\s*false") && !student && !show_commented) ||
        (only_comments && !show_commented)
      if (!skip) {
        items[[length(items) + 1]] <- list(
          type = "code", code = code,
          comment_out = show_commented || has("error:\\s*true"),
          student = student,
          answer = grepl("^Your turn .*: answers$", title) && !student)
      }
      i <- end
    } else if (grepl("^Your turn", title) && !grepl("answers$", title) &&
               grepl("^[0-9]+\\.\\s", line)) {
      items[[length(items) + 1]] <- list(type = "task",
                                         text = sub("^([0-9]+\\.)\\s+", "\\1 ", line))
    }
    i <- i + 1
  }

  # Packages used anywhere in the deck's code
  all_code <- unlist(lapply(items, function(x) if (x$type == "code") x$code))
  pkgs <- unique(sub(".*library\\(([A-Za-z0-9.]+)\\).*", "\\1",
                     grep("^\\s*library\\(", all_code, value = TRUE)))
  # Packages from the tidyverse are installed as one: install.packages("tidyverse");
  # other packages are listed separately. library() calls are not changed.
  tidyverse_core <- c("dplyr", "forcats", "ggplot2", "lubridate", "purrr",
                      "readr", "stringr", "tibble", "tidyr")
  if (any(pkgs %in% c("tidyverse", tidyverse_core))) {
    pkgs <- c("tidyverse", setdiff(pkgs, c("tidyverse", tidyverse_core)))
  }
  install_line <- if (length(pkgs) == 1) paste0('install.packages("', pkgs, '")') else
    paste0("install.packages(c(", paste0('"', pkgs, '"', collapse = ", "), "))")

  build <- function(student) {
    out <- c(
      paste("#", yaml_value("subtitle")),
      paste("#", yaml_value("title"), "--", yaml_value("date")),
      if (student) "# Fill in the ___ blanks in the \"Your turn\" parts." else
        "# With answers: full code from the slides, including the \"Your turn\" tasks.",
      "# Run inside the course project (open moldiveco.Rproj first), so that \"data/genes.csv\" is found.",
      "",
      # library() calls stay where the deck first uses each package
      if (length(pkgs) > 0) c("# Run once if the packages are not installed yet:",
                              paste("#", install_line)))
    section <- NULL      # section header waiting for its first code
    topic <- NULL        # topic header waiting for its first code
    last_topic <- ""
    for (x in items) {
      if (x$type == "section") {
        section <- x$text
        last_topic <- ""
        next
      }
      if (x$type == "topic") {
        topic <- x$text
        next
      }
      if (x$type == "code") {
        if (x$student && !student) next
        if (x$answer && student) next
      }
      # first content of a part: write the headers it needs
      if (!is.null(section)) {
        out <- c(out, "", "", paste("#", section, "####"))
        section <- NULL
      }
      # "Matrices: row and column names" right after "Matrices" is the same topic
      if (!is.null(topic) && startsWith(topic, paste0(last_topic, ":")) && last_topic != "") topic <- last_topic
      if (!is.null(topic) && topic != last_topic) {
        out <- c(out, "", paste("##", topic, "####"))
        last_topic <- topic
      }
      topic <- NULL
      if (x$type == "task") {
        out <- c(out, paste("#", x$text))
      } else {
        code <- x$code
        while (length(code) > 0 && code[1] == "") code <- code[-1]
        while (length(code) > 0 && code[length(code)] == "") code <- code[-length(code)]
        if (x$comment_out) code <- ifelse(code == "" | grepl("^#", code), code, paste("#", code))
        out <- c(out, code)
      }
    }
    c(out, "")
  }

  base <- sub("\\.qmd$", "", qmd)
  writeLines(build(TRUE), paste0(base, ".R"), useBytes = TRUE)
  writeLines(build(FALSE), paste0(base, "_answers.R"), useBytes = TRUE)
  message("Written: ", base, ".R and ", base, "_answers.R")
}
