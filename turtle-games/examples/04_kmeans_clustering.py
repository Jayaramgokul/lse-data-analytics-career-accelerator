"""04. Customer segmentation with k-means (notebook week 3; report section 3.2).

Clusters customers on remuneration and spending score, chooses k with the elbow
(inertia) and silhouette methods, fits k = 5 and describes each segment.

    python 04_kmeans_clustering.py
"""

import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt  # noqa: E402
from sklearn.cluster import KMeans  # noqa: E402
from sklearn.metrics import silhouette_score  # noqa: E402

from common import load_clean, save  # noqa: E402


def main():
    d = load_clean()
    X = d[["remuneration", "spending_score"]]
    print(f"{'k':>3s} {'inertia':>12s} {'silhouette':>11s}")
    inertia, sil = {}, {}
    for k in range(2, 11):
        km = KMeans(n_clusters=k, init="k-means++", max_iter=500, n_init=10, random_state=42).fit(X)
        inertia[k], sil[k] = km.inertia_, silhouette_score(X, km.labels_)
        print(f"{k:3d} {inertia[k]:12,.0f} {sil[k]:11.3f}")
    print(f"Highest silhouette at k = {max(sil, key=sil.get)}")

    km = KMeans(n_clusters=5, init="k-means++", max_iter=15000, n_init=10, random_state=42).fit(X)
    d["cluster"] = km.labels_
    profile = d.groupby("cluster").agg(customers=("age", "size"), remuneration=("remuneration", "mean"),
                                       spending=("spending_score", "mean"), loyalty=("loyalty_points", "mean"))
    profile = profile.sort_values(["remuneration", "spending"]).round(1)
    print("\nk = 5 segments (means):")
    print(profile.to_string())

    fig, ax = plt.subplots(1, 3, figsize=(13, 3.8))
    ax[0].plot(list(inertia), list(inertia.values()), marker="o")
    ax[0].set(xlabel="k", ylabel="Inertia", title="Elbow")
    ax[1].plot(list(sil), list(sil.values()), marker="o", color="#d8543b")
    ax[1].set(xlabel="k", ylabel="Silhouette", title="Silhouette")
    ax[2].scatter(d.remuneration, d.spending_score, c=d.cluster, s=8, cmap="tab10")
    ax[2].set(xlabel="Remuneration (k£)", ylabel="Spending score", title="k = 5 segments")
    print(f"\nChart: {save(fig, '04_kmeans')}")
    print("\nWhat this shows: both methods point to five groups. Low and high earners each split into low and\n"
          "high spenders, with a large middle group in between. Those five segments are the basis of the\n"
          "report's marketing recommendations.")


if __name__ == "__main__":
    main()
