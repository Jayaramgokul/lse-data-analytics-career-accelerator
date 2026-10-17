"""08. Combining segments and sentiment (report sections 6-7).

The report's main recommendation: cross the five spending-remuneration segments
with review sentiment and act on each combination, for example re-engaging
low-earning, high-spending customers whose reviews are negative before they churn.
This example builds that table from the k-means segments (04) and TextBlob
polarity (05).

    python 08_segments_and_sentiment.py
"""

import re

import pandas as pd
from sklearn.cluster import KMeans
from textblob import TextBlob

from common import load_clean

ACTIONS = {
    ("High", "Low", "negative"): "survey pain points; review product features losing customers",
    ("High", "Low", "positive"): "extend campaigns so products reach these customers",
    ("Low", "High", "negative"): "at risk: immediate intervention and offers",
    ("Low", "High", "positive"): "retention-oriented campaigns and offers",
    ("Low", "Low", None): "smaller-scale re-engagement",
    ("Mid", "Mid", None): "steady growth, watch preferences",
    ("High", "High", None): "premium retention rewards",
}


def main():
    d = load_clean()
    km = KMeans(n_clusters=5, init="k-means++", max_iter=15000, n_init=10, random_state=42)
    d["cluster"] = km.fit_predict(d[["remuneration", "spending_score"]])
    centres = d.groupby("cluster")[["remuneration", "spending_score"]].mean()

    def level(v, lo, hi):
        return "Low" if v < lo else "High" if v > hi else "Mid"
    names = {c: (level(r.remuneration, 35, 60), level(r.spending_score, 35, 65)) for c, r in centres.iterrows()}
    d["segment"] = d.cluster.map(lambda c: f"{names[c][0]} pay / {names[c][1]} spend")

    pol = d.review.map(lambda t: TextBlob(re.sub(r"[^\w\s]", "", str(t).lower())).sentiment.polarity)
    d["sentiment"] = pd.cut(pol, [-1.01, -0.05, 0.05, 1.01], labels=["negative", "neutral", "positive"])

    table = pd.crosstab(d.segment, d.sentiment)
    table["negative share"] = (table["negative"] / table.sum(axis=1)).round(3)
    print("Customers by segment and review sentiment:\n")
    print(table.to_string())

    print("\nRecommended action per combination (report section 7):")
    for c, (pay, spend) in sorted(names.items(), key=lambda t: t[1]):
        in_segment = d.cluster == c
        if (pay, spend, None) in ACTIONS:
            print(f"  {pay:>4s} pay / {spend:<4s} spend, all      ({int(in_segment.sum()):4d} customers): "
                  f"{ACTIONS[(pay, spend, None)]}")
            continue
        for s in ["negative", "positive"]:
            n = int((in_segment & (d.sentiment == s)).sum())
            print(f"  {pay:>4s} pay / {spend:<4s} spend, {s:8s} ({n:4d} customers): {ACTIONS[(pay, spend, s)]}")
    print("\nWhat this shows: segments say who a customer is; sentiment says how they feel. Crossing the two\n"
          "turns a clustering exercise into a short list of marketing actions, each attached to a group of a\n"
          "known size, and the report suggests tracking conversion and retention to check each one works.")


if __name__ == "__main__":
    main()
