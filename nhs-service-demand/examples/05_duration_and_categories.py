"""05. Appointment duration, national categories and service settings (report Figs 4.10-4.15;
notebook section C, 2-3).

Duration comes from actual_duration (Dec 2021 - Jun 2022). The type of
appointment (national category) and where it happened (service setting) come
from national_categories (Aug 2021 - Jun 2022). Following the notebook, the
category analysis keeps the five main categories (common.MAIN_CATEGORIES),
which hold 96% of mapped appointments.

    python 05_duration_and_categories.py
"""

import matplotlib.pyplot as plt
import seaborn as sns

from common import DURATION_ORDER, MAIN_CATEGORIES, known, load_ad, load_nc, millions, save, shares


def main():
    ad, nc = load_ad(), load_nc()

    d = known(ad, "actual_duration")
    counts, _ = shares(d, "appointment_month", "actual_duration")
    counts = counts[DURATION_ORDER]
    tot = counts.sum()
    print("Fig 4.10: appointments by duration (known durations only)")
    for k in DURATION_ORDER:
        print(f"  {k:<14} {millions(tot[k]):>8}  {tot[k] / tot.sum() * 100:5.1f}%")
    short = (tot["1-5 Minutes"] + tot["6-10 Minutes"]) / tot.sum() * 100
    unknown_share = ad[ad.actual_duration.isin(["Unknown / Data Quality"])].count_of_appointments.sum() / ad.count_of_appointments.sum() * 100
    print(f"  1-10 minutes: {short:.1f}% of appointments with a recorded duration "
          f"({unknown_share:.0f}% of all appointments have no usable duration)")
    peak = counts.sum(axis=1).idxmax()
    print(f"  busiest month: {peak}\n")
    fig, ax = plt.subplots(figsize=(10, 5))
    sns.heatmap(counts, annot=True, fmt=".0f", cmap="YlGnBu", ax=ax, annot_kws={"size": 7})
    ax.set_title("Appointments by duration and month")
    save(fig, "fig4_10_duration_by_month.png")

    mapped = known(nc, "national_category")
    cat = mapped.groupby("national_category").count_of_appointments.sum().sort_values(ascending=False)
    print("Fig 4.11: appointments by national category")
    for k, v in cat.items():
        print(f"  {k[:60]:<60} {millions(v):>8}")
    print(f"  the five main categories hold {cat[MAIN_CATEGORIES].sum() / cat.sum() * 100:.0f}% of mapped appointments\n")

    five = nc[nc.national_category.isin(MAIN_CATEGORIES)]
    counts, pct = shares(five, "service_setting", "national_category")
    print("Figs 4.12-4.13: category mix within each service setting (five main categories)")
    print((counts / 1e6).round(2).assign(total=counts.sum(axis=1) / 1e6).round(2).to_string())
    print(pct.round(1).to_string(), "\n")
    fig, ax = plt.subplots(figsize=(9, 5))
    pct.plot(kind="barh", stacked=True, ax=ax, colormap="YlGnBu")
    ax.set_xlabel("% of appointments")
    ax.set_title("National category mix by service setting")
    ax.legend(fontsize=7, loc="center left", bbox_to_anchor=(1, 0.5))
    save(fig, "fig4_12_13_category_by_setting.png")

    _, pct = shares(five, "appointment_month", "national_category")
    print("Fig 4.14: monthly share of each main category (min - max)")
    print(pct.round(1).agg(["min", "max"]).T.to_string(), "\n")

    s = known(nc, "service_setting")
    counts, pct = shares(s, "appointment_month", "service_setting")
    total = s.groupby("service_setting").count_of_appointments.sum()
    print("Fig 4.15: service settings (Unmapped excluded)")
    for k, v in total.sort_values(ascending=False).items():
        print(f"  {k:<26} {millions(v):>8}  {v / total.sum() * 100:5.1f}%   "
              f"monthly share {pct[k].min():.2f}% to {pct[k].max():.2f}%")
    print(f"  Extended Access Provision: {counts['Extended Access Provision'].min():,.0f} to "
          f"{counts['Extended Access Provision'].max():,.0f} appointments a month")
    fig, ax = plt.subplots(figsize=(10, 4.5))
    pct.drop(columns="General Practice").plot(ax=ax, marker="o")
    ax.set_ylabel("% of appointments")
    ax.set_title("Non-GP-practice service settings, monthly share")
    save(fig, "fig4_15_settings_by_month.png")

    print("\nWhat this shows: general practice is overwhelmingly short, routine work. Nearly half of the\n"
          "appointments with a recorded duration last ten minutes or less, and routine consultations are\n"
          "the largest category in every setting but Extended Access Provision (where acute, routine and\n"
          "triage are almost even). About 95% of appointments happen in general practice\n"
          "itself; Primary Care Networks and Extended Access Provision handle 2-3% and under 1%. Their\n"
          "share is small but growing (PCN 1.9% to 2.8% over the eleven months), which is why the report\n"
          "points to them as the place to move routine and planned work off GP practices.")


if __name__ == "__main__":
    main()
