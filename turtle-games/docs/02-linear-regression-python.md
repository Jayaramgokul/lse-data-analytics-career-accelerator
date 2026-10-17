# 2. Linear regression in Python

*Report section 3.1. Notebook week 1, sections 5–6. Example: [`02_linear_regression.py`](../examples/02_linear_regression.py).*

## What was done

The first question was how far loyalty points can be explained by a straight
line in each predictor. Using `statsmodels` OLS:

1. **Simple regressions:** loyalty points on spending score, on remuneration,
   and on age, each with its fitted line, residual histogram and a
   Breusch–Pagan test for heteroskedasticity.
2. **Multiple regression** on all three predictors, with its coefficient
   table, residual histogram and residuals-vs-fitted plot.

## Results

| Model | R² | Breusch–Pagan |
|---|---|---|
| Spending score only | 0.45 | constant variance rejected |
| Remuneration only | 0.38 | constant variance rejected |
| Age only | 0.00 | constant variance rejected |
| All three | **0.84** | constant variance rejected |

In the combined model, each extra point of spending score or £1k of
remuneration adds about 34 loyalty points. Age adds about 11 per year, once
the other two are held fixed.

## What the diagnostics said

- **Heteroskedasticity:** the residuals fan out as fitted values grow. The
  model is less precise for high-loyalty customers, the ones that matter
  most.
- **Curvature:** a bend in the residuals-vs-fitted plot shows the
  relationship is not linear, especially at high spending and remuneration
  (report section 3.1).
- **Impossible values:** some predictions are negative, which loyalty points
  cannot be.

The report concluded that "non-linear models should be considered". That led
to the decision tree ([3](03-decision-tree.md)) and to the curved linear
variants tested in R ([7](07-r-regression.md)).
