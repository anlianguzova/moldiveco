# Simulated toy data for 00_template.qmd (not real measurements)
set.seed(42)
n <- 30
dat <- data.frame(
  gene = sprintf("gene_%02d", 1:n),
  group = rep(c("control", "treatment"), each = n / 2),
  gc_content = round(runif(n, 0.35, 0.65), 3)
)
dat$expression <- round(5 + 6 * dat$gc_content + 1.5 * (dat$group == "treatment") + rnorm(n, 0, 0.8), 2)
write.csv(dat, "data/template_example.csv", row.names = FALSE)
