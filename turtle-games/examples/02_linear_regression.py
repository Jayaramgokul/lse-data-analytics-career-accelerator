"""02. Linear regression in Python (notebook week 1, sections 5-6).

One predictor at a time (spending score, remuneration, age), then all three
together, fitted with statsmodels OLS on the full data as in the notebook, with a
Breusch-Pagan test for heteroskedasticity and the residuals checked for shape.

    python 02_linear_regression.py
"""

import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt  # noqa: E402
import statsmodels.formula.api as smf  # noqa: E402
from statsmodels.stats.diagnostic import het_breuschpagan  # noqa: E402

from common import load_clean, save  # noqa: E402


def main():
    d = load_clean()
    print(f"{'model':45s} {'R2':>6s} {'Breusch-Pagan p':>16s}")
    fits = {}
    for f in ["loyalty_points ~ spending_score", "loyalty_points ~ remuneration", "loyalty_points ~ age",
              "loyalty_points ~ age + remuneration + spending_score"]:
        m = smf.ols(f, data=d).fit()
        bp = het_breuschpagan(m.resid, m.model.exog)[1]
        fits[f] = m
        print(f"{f:45s} {m.rsquared:6.3f} {bp:16.2g}")

    mlr = fits["loyalty_points ~ age + remuneration + spending_score"]
    print("\nMultiple regression coefficients:")
    print(mlr.summary2().tables[1][["Coef.", "Std.Err.", "P>|t|"]].round(3).to_string())

    fig, ax = plt.subplots(1, 2, figsize=(10, 3.6))
    ax[0].scatter(mlr.fittedvalues, mlr.resid, s=6, alpha=0.4)
    ax[0].axhline(0, color="#d8543b")
    ax[0].set(xlabel="Fitted loyalty points", ylabel="Residual", title="Residuals vs fitted")
    ax[1].hist(mlr.resid, bins=40, color="#3182bd")
    ax[1].set(xlabel="Residual", title="Residual distribution")
    print(f"\nChart: {save(fig, '02_mlr_residuals')}")
    print("\nWhat this shows: spending score and remuneration each explain a good share of loyalty points on\n"
          "their own and age almost none; together they explain about 84%. But the Breusch-Pagan tests reject\n"
          "constant variance and the residuals fan out and curve, so the straight-line form is not the whole\n"
          "story. That is why the project went on to decision trees.")


if __name__ == "__main__":
    main()
