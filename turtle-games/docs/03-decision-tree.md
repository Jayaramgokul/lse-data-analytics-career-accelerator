# 3. Decision tree regression

*Report sections 4–5 (non-linear models). Notebook week 2. Example: [`03_decision_tree.py`](../examples/03_decision_tree.py).*

## Why a tree

A decision tree predicts by splitting customers on thresholds (for example,
"spending score above one value and remuneration above another"). It can follow the bends the linear
models missed without anyone specifying their shape.

## The procedure

The procedure was designed to keep the final score honest.

1. **Split three ways:** 70% training, 15% validation, 15% test
   (`random_state=42`). The test set is touched only once, at the end.
2. **Starting point:** a tree of depth 4. Test R² 0.944.
3. **Tuning by cross-validation on the training data only.** 120 combinations
   of `max_depth` (1–6), `min_samples_leaf` (1, 2, 5, 10, 20) and
   `min_samples_split` (2, 5, 10, 20), each scored by 5-fold cross-validated
   MAE (also RMSE and R²). Best: **depth 6, leaf 5, split 10**. Limiting depth
   and leaf size is how overfitting was controlled.
4. **Stability of feature importance:** the tuned tree refitted on 30
   bootstrap samples of train + validation.
5. **Permutation importance:** for each of 5 folds, shuffle one feature at a
   time and measure how much the validation MAE worsens, repeated 20 times.
6. **Final model:** refitted on train + validation, scored once on the test
   set.

## Results

| Model | Test RMSE | Test MAE | R² |
|---|---|---|---|
| Best linear model, MLR with age² ([7](07-r-regression.md)) | 518.57 | 374.47 | 0.851 |
| **Tuned decision tree** | **228.48** | **137.73** | **0.969** |

The tree more than halves the error of the best linear model. (The report's
table shows MAE 137.373; the notebook's own output is 137.733, so two digits
were swapped in the table.)

**Which features matter:**

| Feature | Bootstrap importance (mean ± sd) | Rise in MAE when shuffled |
|---|---|---|
| Spending score | 0.509 ± 0.054 | +836 |
| Remuneration | 0.480 ± 0.054 | +607 |
| Age | 0.010 ± 0.003 | +50 |

Spending score and remuneration share the importance almost equally, and
their ranges overlap across bootstrap samples. Either can drive a split at
any depth without dominating the other. Age contributes little.

## Diagnostics

The residuals show **vertical stripes**, which is normal for trees: every
customer in a leaf gets the same prediction. Their spread differs across the
fitted range, so the error is **heteroskedastic**: the tree is more accurate
for some segments than others.

The report chose the tuned tree as the final model, with the linear model as
the interpretable baseline. As next steps it suggested random forests or
gradient boosting, if interpretability allows, to reduce a single tree's
variance.
