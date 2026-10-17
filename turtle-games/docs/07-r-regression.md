# 7. Multiple linear regression and its alternatives in R

*Report sections 4–5 (linear models). R script, assignment 6. Example: [`07_r_regression.R`](../examples/07_r_regression.R).*

## The procedure

- **Split:** 80/20 train/test (`set.seed(42)`).
- **Search:** predictors were added one at a time, and a change was kept only
  if test error improved or the diagnostics stabilised.
- **Scoring:** each model was judged on predictive accuracy (test RMSE, MAE,
  R²) and on four diagnostics:
  - residual normality (Shapiro–Wilk, Q–Q plot, skewness and kurtosis);
  - constant variance (Breusch–Pagan);
  - multicollinearity (VIF);
  - influential points (Cook's distance), plus component-residual plots.

## The models

| Model | Predictors | Test RMSE | Test MAE | R² |
|---|---|---|---|---|
| MLR-1 | spending score + remuneration + age | 548.27 | 427.69 | 0.838 |
| MLR-2 | + age² | **518.57** | **374.47** | 0.851 |
| Log target | log(1 + loyalty points), + age² | 1,033.20 | 553.32 | 0.823 |

The script also tests squaring all three predictors (test RMSE 521.04). It
fits no better than MLR-2.

## What the diagnostics said (MLR-1)

- **Normality rejected** (Shapiro–Wilk p ≈ 10⁻¹⁰): the residuals are skewed.
- **Constant variance rejected** (Breusch–Pagan p ≈ 10⁻⁸): errors grow with
  the fitted value.
- **No multicollinearity:** all VIFs are about 1. The three predictors carry
  separate information.
- **Influential points:** 197 training rows are above the usual Cook's
  distance threshold (4/n).
- **Negative predictions:** 33 test customers are predicted below zero.

## How each change helped, and where it stopped

- **Age²** improved accuracy, confirming the curve seen in the residuals.
- **The log target** made negative predictions impossible but forecast worse
  once converted back to points.
- **Neither fixed the underlying problem.** Non-linear structure remained in
  the residuals.

The report's conclusion: "the linear form limits for this dataset". MLR-2 is
kept as the **interpretable baseline**, and the decision tree
([3](03-decision-tree.md)) as the final model.

*Note: the report's log-model row includes age², which is how its figures
were produced. The final version of the submitted R script fits the log model
without age², which gives a test RMSE of 1,006.6.*
