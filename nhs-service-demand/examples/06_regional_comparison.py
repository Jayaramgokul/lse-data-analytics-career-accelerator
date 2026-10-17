"""06. Comparing the busiest and quietest ICBs (report Figs 4.16-4.25; notebook section D).

Ranks the 42 Integrated Care Boards (ICBs) by total appointments, then compares
the top five and bottom five on every appointment variable, as the report does.
The two groups are checked against the totals in all three datasets.

    python 06_regional_comparison.py
"""

import matplotlib.pyplot as plt

from common import BOTTOM5, DURATION_ORDER, LEAD_TIME_ORDER, TOP5, known, load_ad, load_ar, load_nc, save, shares


def compare(df, var, order=None, label=None):
    d = known(df, var) if var in ("appointment_status", "hcp_type", "appointment_mode",
                                  "time_between_book_and_appointment", "actual_duration",
                                  "service_setting") else df
    _, pct = shares(d[d.icb_ons_code.isin(TOP5 + BOTTOM5)], "icb_ons_code", var)
    if order:
        pct = pct[order]
    print(f"\n{label or var}: % of each ICB's appointments")
    for name, codes in [("top 5", TOP5), ("bottom 5", BOTTOM5)]:
        print(f"  {name}")
        print("    " + pct.loc[codes].round(1).to_string().replace("\n", "\n    "))
    return pct


def main():
    ar, ad, nc = load_ar(), load_ad(), load_nc()
    rank = ar.groupby("icb_ons_code").count_of_appointments.sum().sort_values(ascending=False)
    print("Fig 4.16: ICBs ranked by total appointments (Jan 2020 - Jun 2022)")
    print(f"  top 5:    {', '.join(f'{k} ({v / 1e6:.1f}M)' for k, v in rank.head(5).items())}")
    print(f"  bottom 5: {', '.join(f'{k} ({v / 1e6:.1f}M)' for k, v in rank.tail(5).items())}")
    print(f"  the busiest ICB has {rank.iloc[0] / rank.iloc[-1]:.1f} times the appointments of the quietest")
    for name, df in [("actual_duration", ad), ("national_categories", nc)]:
        r = df.groupby("icb_ons_code").count_of_appointments.sum().sort_values(ascending=False)
        same = set(r.index[:5]) == set(TOP5) and set(r.index[-5:]) == set(BOTTOM5)
        print(f"  same top and bottom five in {name}: {same}")

    mode = compare(ar, "appointment_mode", label="Fig 4.17: appointment mode")
    compare(ar, "appointment_status", label="Fig 4.18: appointment status")
    hcp = compare(ar, "hcp_type", label="Fig 4.19: healthcare professional type")
    lead = compare(ar, "time_between_book_and_appointment", LEAD_TIME_ORDER, "Fig 4.20: booking lead time")
    dur = compare(ad, "actual_duration", DURATION_ORDER, "Figs 4.21-4.22: actual duration")
    setting = compare(nc, "service_setting", label="Fig 4.25: service setting (Unmapped excluded)")

    five = known(nc, "national_category")
    heat = five[five.icb_ons_code.isin(TOP5 + BOTTOM5)].pivot_table(
        index="national_category", columns="icb_ons_code", values="count_of_appointments", aggfunc="sum").fillna(0)
    print("\nFig 4.24: largest categories, top 5 vs bottom 5 (millions)")
    for c in ["General Consultation Routine", "General Consultation Acute", "Clinical Triage"]:
        print(f"  {c:<30} top: {', '.join(f'{heat.loc[c, k] / 1e6:.1f}' for k in TOP5)}   "
              f"bottom: {', '.join(f'{heat.loc[c, k] / 1e6:.1f}' for k in BOTTOM5)}")

    fig, axes = plt.subplots(1, 2, figsize=(12, 5), sharey=True)
    for ax, codes, title in [(axes[0], TOP5, "Top 5 ICBs"), (axes[1], BOTTOM5, "Bottom 5 ICBs")]:
        lead.loc[codes].plot(kind="bar", stacked=True, ax=ax, colormap="Set2", legend=ax is axes[1])
        ax.set_title(f"{title}: booking lead time")
        ax.set_ylabel("% of appointments")
    axes[1].legend(fontsize=7, loc="center left", bbox_to_anchor=(1, 0.5))
    save(fig, "fig4_20_lead_time_by_icb.png")

    print("\nSummary ranges across all ten ICBs:")
    print(f"  same-day bookings      {lead['Same Day'].min():.1f}% to {lead['Same Day'].max():.1f}%")
    print(f"  2-7 days ahead         {lead['2 to 7 Days'].min():.1f}% to {lead['2 to 7 Days'].max():.1f}%")
    print(f"  GP share               {hcp.GP.min():.1f}% to {hcp.GP.max():.1f}%")
    print(f"  face-to-face           {mode['Face-to-Face'].min():.1f}% to {mode['Face-to-Face'].max():.1f}%")
    print(f"  1-10 minute slots      {(dur['1-5 Minutes'] + dur['6-10 Minutes']).min():.1f}% to "
          f"{(dur['1-5 Minutes'] + dur['6-10 Minutes']).max():.1f}%")
    print(f"  general practice       {setting['General Practice'].min():.1f}% to {setting['General Practice'].max():.1f}%")

    print("\nWhat this shows: the busiest ICBs are not run differently from the quietest ones. Across all ten,\n"
          "attendance stays at 94-97%, face-to-face at 54-68%, same-day bookings at 41-50% and general\n"
          "practice at 92-97% of appointments. The differences are of degree: E54000057 has the highest DNA\n"
          "rate (6.0%), E54000034 and E54000027 lean most on GPs (59.7% and 57.6%), and E54000034 and\n"
          "E54000008 use the telephone most (45.4% and 41.2%). Volume differences, not practice differences,\n"
          "are what separate the groups, so capacity planning should follow population and demand.")


if __name__ == "__main__":
    main()
