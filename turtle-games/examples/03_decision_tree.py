"""03. Decision tree regression (notebook week 2; report sections 4-5).

Follows the notebook: a 70/15/15 train/validation/test split; an initial tree of
depth 4; a cross-validated search over max_depth (1-6), min_samples_leaf and
min_samples_split ranked by MAE; feature-importance stability over 30 bootstrap
samples; permutation importance (change in MAE) across 5 folds; and a final tree
refitted on train + validation and scored on the untouched test set.

    python 03_decision_tree.py
"""

import warnings

import numpy as np
import pandas as pd
from sklearn.inspection import permutation_importance
from sklearn.metrics import mean_absolute_error, mean_squared_error, r2_score
from sklearn.model_selection import KFold, cross_val_score, train_test_split
from sklearn.tree import DecisionTreeRegressor
from sklearn.utils import resample

from common import load_clean

warnings.filterwarnings("ignore")
FEATURES = ["age", "remuneration", "spending_score"]


def scores(y, p):
    return mean_absolute_error(y, p), np.sqrt(mean_squared_error(y, p)), r2_score(y, p)


def main():
    d = load_clean()
    X, y = d[FEATURES], d.loyalty_points
    X_train, X_rest, y_train, y_rest = train_test_split(X, y, test_size=0.30, random_state=42)
    X_val, X_test, y_val, y_test = train_test_split(X_rest, y_rest, test_size=0.50, random_state=42)

    first = DecisionTreeRegressor(max_depth=4, random_state=1).fit(X_train, y_train)
    print("Initial tree (depth 4) on test: MAE {:.1f}, RMSE {:.1f}, R2 {:.3f}".format(*scores(y_test, first.predict(X_test))))

    cv = KFold(5, shuffle=True, random_state=42)
    rows = []
    for depth in range(1, 7):
        for leaf in [1, 2, 5, 10, 20]:
            for split in [2, 5, 10, 20]:
                p = {"max_depth": depth, "min_samples_leaf": leaf, "min_samples_split": split}
                mae = -cross_val_score(DecisionTreeRegressor(random_state=42, **p), X_train, y_train, cv=cv,
                                       scoring="neg_mean_absolute_error").mean()
                rows.append({**p, "cv_mae": mae})
    grid = pd.DataFrame(rows).sort_values("cv_mae")
    best = grid.iloc[0][["max_depth", "min_samples_leaf", "min_samples_split"]].astype(int).to_dict()
    print(f"\n{len(grid)} parameter sets searched; best by CV MAE: {best} (CV MAE {grid.iloc[0].cv_mae:.1f})")

    X_tv, y_tv = pd.concat([X_train, X_val]), pd.concat([y_train, y_val])
    imps = np.array([DecisionTreeRegressor(random_state=42, **best).fit(*resample(X_tv, y_tv, random_state=42 + b))
                     .feature_importances_ for b in range(30)])
    print("\nFeature importance over 30 bootstrap samples (mean +/- sd):")
    for f, m, s in sorted(zip(FEATURES, imps.mean(0), imps.std(0)), key=lambda t: -t[1]):
        print(f"  {f:15s} {m:.3f} +/- {s:.3f}")

    deltas = []
    for tr, va in KFold(5, shuffle=True, random_state=42).split(X_tv):
        m = DecisionTreeRegressor(random_state=42, **best).fit(X_tv.iloc[tr], y_tv.iloc[tr])
        perm = permutation_importance(m, X_tv.iloc[va], y_tv.iloc[va], n_repeats=20, random_state=42,
                                      scoring="neg_mean_absolute_error")
        deltas.append(perm.importances_mean)          # baseline score minus shuffled score = rise in MAE
    print("\nPermutation importance (increase in MAE when the feature is shuffled), mean over 5 folds:")
    for f, v in sorted(zip(FEATURES, np.mean(deltas, axis=0)), key=lambda t: -t[1]):
        print(f"  {f:15s} {v:+.1f}")

    final = DecisionTreeRegressor(random_state=42, **best).fit(X_tv, y_tv)
    print("\nFinal tuned tree on the untouched test set: MAE {:.3f}, RMSE {:.3f}, R2 {:.3f}".format(
        *scores(y_test, final.predict(X_test))))
    print("Report table: RMSE 228.479, MAE 137.373, R2 0.969 (the notebook's own output gives MAE 137.733;\n"
          "the table swapped two digits). Best linear model, for comparison: R2 0.851")
    print("\nWhat this shows: a tree splits customers into groups by thresholds instead of drawing one line, so\n"
          "it follows the bends the linear model missed. Tuning by cross-validation on the training data, then\n"
          "scoring once on held-out test data, keeps the comparison honest. Spending score and remuneration\n"
          "share the importance almost equally; age adds little.")


if __name__ == "__main__":
    main()
