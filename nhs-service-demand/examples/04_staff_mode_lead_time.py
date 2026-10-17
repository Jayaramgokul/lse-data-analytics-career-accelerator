"""04. Who sees patients, how, and how far ahead (report Figs 4.5-4.9; notebook section C, 1.2-1.3).

Healthcare professional type and appointment mode, against each other, booking
lead time and month.

Fig 4.8 (lead time by mode) in the report shows only four of its seven bars.
The notebook reordered the lead times with a list typed with single spaces
("8 to 14 Days"), but the data labels have double spaces ("8  to 14 Days"), so
reindex() found no match for three categories and left them empty. This
script orders by the labels as they appear in the data (common.LEAD_TIME_ORDER).

    python 04_staff_mode_lead_time.py
"""

import matplotlib.pyplot as plt

from common import LEAD_TIME_ORDER, known, load_ar, save, shares


def stacked_pct(pct, title, name):
    fig, ax = plt.subplots(figsize=(9, 5))
    pct.plot(kind="bar", stacked=True, ax=ax, colormap="tab10", width=0.8)
    ax.set_title(title)
    ax.set_ylabel("% of appointments")
    ax.tick_params(axis="x", rotation=30)
    ax.legend(fontsize=8, loc="center left", bbox_to_anchor=(1, 0.5))
    save(fig, name)


def main():
    ar = load_ar()
    lt = "time_between_book_and_appointment"

    _, pct = shares(known(ar, "hcp_type", "appointment_mode"), "appointment_mode", "hcp_type")
    print("Fig 4.5: share of each mode delivered by GPs vs other practice staff")
    print(pct.round(1).to_string(), "\n")
    stacked_pct(pct, "Professional type by appointment mode", "fig4_5_hcp_by_mode.png")

    _, pct = shares(known(ar, "hcp_type", lt), lt, "hcp_type")
    pct = pct.reindex(LEAD_TIME_ORDER)
    print("Fig 4.6: professional type by booking lead time")
    print(pct.round(1).to_string(), "\n")
    stacked_pct(pct, "Professional type by booking lead time", "fig4_6_hcp_by_lead_time.png")

    _, pct = shares(known(ar, "hcp_type"), "appointment_month", "hcp_type")
    print(f"Fig 4.7: GP share by month ranges {pct.GP.min():.1f}% to {pct.GP.max():.1f}%\n")

    counts, pct = shares(known(ar, "appointment_mode", lt), lt, "appointment_mode")
    counts, pct = counts.reindex(LEAD_TIME_ORDER), pct.reindex(LEAD_TIME_ORDER)
    print("Fig 4.8: appointment mode by booking lead time (all seven lead times)")
    print(pct.round(1).to_string())
    single = [k.replace("  ", " ") for k in LEAD_TIME_ORDER]
    missing = [k for k in single if k not in counts.index]
    print(f"  with single-spaced labels, reindex finds no data for: {', '.join(missing)}\n")
    stacked_pct(pct, "Appointment mode by booking lead time", "fig4_8_mode_by_lead_time.png")

    counts, pct = shares(known(ar, "appointment_mode"), "appointment_month", "appointment_mode")
    print("Fig 4.9: mode share by month")
    print(pct.round(1).agg(["min", "max"]).to_string())
    for m in ["2020-01", "2020-04", "2022-06"]:
        print(f"  {m}: face-to-face {pct.loc[m, 'Face-to-Face']:.1f}%, telephone {pct.loc[m, 'Telephone']:.1f}%")
    fig, ax = plt.subplots(figsize=(10, 4.5))
    pct[["Face-to-Face", "Telephone"]].plot(ax=ax, marker="o")
    ax.set_ylabel("% of appointments")
    ax.set_title("Face-to-face vs telephone share by month")
    save(fig, "fig4_9_mode_by_month.png")

    print("\nWhat this shows: GPs carry most telephone work (71.8%) and most same-day appointments (67.8%),\n"
          "while other practice staff carry most face-to-face work and most appointments booked weeks ahead\n"
          "(76.3% of those booked more than 28 days out). Same-day demand is split almost evenly between\n"
          "telephone and face-to-face; the longer the lead time, the more likely the appointment is face to\n"
          "face. The pandemic shift is visible by month: telephone went from about 15% of appointments in\n"
          "January 2020 to half in April 2020, and face-to-face had recovered to two-thirds by June 2022.")


if __name__ == "__main__":
    main()
