# 07. Multiple linear regression and its alternatives in R (R script, assignment 6;
#     report section 4, linear model iterations).
#
# 80/20 train/test split with set.seed(42), as in the submitted script, then:
#   MLR-1  loyalty_points ~ spending_score + remuneration + age
#   MLR-2  the same + age^2
#   MLR-3  squares of all three predictors
#   Log    log1p(loyalty_points) ~ spending_score + remuneration + age + age^2
# Each is scored on the test set (RMSE, MAE) and MLR-1 is checked with Shapiro-Wilk,
# Breusch-Pagan, VIF and Cook's distance.
#
#   Rscript 07_r_regression.R

suppressPackageStartupMessages({
  library(dplyr)
  library(car)
  library(lmtest)
  library(Metrics)
})

turtle <- read.csv("../data/turtle_reviews.csv", check.names = FALSE) %>%
  select(-language, -platform, -review, -summary) %>%
  rename(remuneration = `remuneration (k£)`, spending_score = `spending_score (1-100)`)

set.seed(42)
idx <- sample.int(nrow(turtle), size = floor(0.8 * nrow(turtle)))
train <- turtle[idx, ]
test <- turtle[-idx, ]

models <- list(
  "MLR-1" = lm(loyalty_points ~ spending_score + remuneration + age, data = train),
  "MLR-2 (+ age^2)" = lm(loyalty_points ~ spending_score + remuneration + age + I(age^2), data = train),
  "MLR-3 (all squared)" = lm(loyalty_points ~ spending_score + I(spending_score^2) + remuneration +
                               I(remuneration^2) + age + I(age^2), data = train),
  "Log1p target" = lm(log1p(loyalty_points) ~ spending_score + remuneration + age + I(age^2), data = train)
)

cat(sprintf("%-22s %10s %10s %8s %8s\n", "model", "test RMSE", "test MAE", "R2", "adj R2"))
for (name in names(models)) {
  m <- models[[name]]
  pred <- predict(m, newdata = test)
  if (name == "Log1p target") pred <- expm1(pred)          # back to the points scale
  s <- summary(m)
  cat(sprintf("%-22s %10.2f %10.2f %8.4f %8.4f\n", name, rmse(test$loyalty_points, pred),
              mae(test$loyalty_points, pred), s$r.squared, s$adj.r.squared))
}
cat("Report: MLR-1 548.27 / 427.69 / R2 0.8381; MLR-2 518.57 / 374.47 / adj R2 0.8512; log 1033.20 / 553.32 / adj R2 0.8231\n")

m1 <- models[["MLR-1"]]
cat("\nDiagnostics for MLR-1:\n")
cat(sprintf("  Shapiro-Wilk on residuals:      p = %.2g (normality rejected if small)\n", shapiro.test(residuals(m1))$p.value))
cat(sprintf("  Breusch-Pagan:                  p = %.2g (constant variance rejected if small)\n", bptest(m1)$p.value))
v <- vif(m1)
cat(sprintf("  VIF: %s (no multicollinearity concern below 5)\n", paste(sprintf("%s %.2f", names(v), v), collapse = ", ")))
cooks <- cooks.distance(m1)
cat(sprintf("  Cook's distance above 4/n: %d of %d training rows\n", sum(cooks > 4 / nrow(train)), nrow(train)))
cat(sprintf("  Negative predictions on the test set: %d\n", sum(predict(m1, test) < 0)))

cat("\nWhat this shows: adding age^2 improves the fit, confirming the curve seen in the residuals, and\n",
    "the log target removes impossible negative predictions but forecasts worse on the original scale.\n",
    "The diagnostics reject normal, constant-variance errors: the linear family is a useful, interpretable\n",
    "baseline, but its form does not match the data, which is why the tree was preferred.\n", sep = "")
