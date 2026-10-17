"""01. The data and its preparation (report sections 1-2; notebook week 1, sections 1-4).

Loads the 2,000 customer reviews, checks for missing values and duplicates, drops
the two constant columns (language, platform), renames the two long column names,
and splits the fields into the two workflows the project used: structured fields
for modelling and clustering, text fields for sentiment.

    python 01_data_preparation.py
"""

from common import DATA, OUT, load_clean
import pandas as pd


def main():
    raw = pd.read_csv(DATA)
    print(f"Raw data: {raw.shape[0]:,} rows, {raw.shape[1]} columns")
    print(f"Missing values: {int(raw.isna().sum().sum())}; duplicate rows: {int(raw.duplicated().sum())}")
    print(f"language values: {sorted(raw.language.unique())}; platform values: {sorted(raw.platform.unique())}"
          "  -> constant, so dropped")

    d = load_clean()
    d.to_csv(OUT / "turtle_reviews_cleaned.csv", index=False)
    structured = ["gender", "age", "remuneration", "spending_score", "loyalty_points", "education", "product"]
    text = ["review", "summary"]
    print(f"\nStructured workflow ({len(structured)} fields): {', '.join(structured)}")
    print(f"Text workflow ({len(text)} fields): {', '.join(text)}")
    print("\nNumeric summary:")
    print(d[["age", "remuneration", "spending_score", "loyalty_points"]].describe().round(1).to_string())
    skew = d.loyalty_points.skew()
    print(f"\nloyalty_points skewness: {skew:.2f} (right-skewed: a few customers hold very high balances)")
    print(f"Cleaned file: {OUT / 'turtle_reviews_cleaned.csv'}")
    print("\nWhat this shows: the data is complete and free of duplicate rows, two columns carry no information,\n"
          "and the target, loyalty_points, is strongly right-skewed. That skew is the first hint that a straight-\n"
          "line model may struggle, which the later sections confirm.")


if __name__ == "__main__":
    main()
