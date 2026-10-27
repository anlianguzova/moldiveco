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
update_geom_defaults("point", list(shape = 19, size = 3))

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
