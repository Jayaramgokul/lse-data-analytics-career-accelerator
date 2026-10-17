"""03. Attendance and missed appointments (report Figs 4.1-4.4; notebook section C, 1.1).

Appointment status (Attended vs DNA, "did not attend") against appointment
mode, healthcare professional type, booking lead time and month.

    python 03_attendance.py
"""

import matplotlib.pyplot as plt

from common import LEAD_TIME_ORDER, known, load_ar, save, shares


def stacked(pct, counts, title, name):
    fig, ax = plt.subplots(figsize=(9, 5))
    bottom = 0
    for status, colour in [("Attended", "#4CAF50"), ("DNA", "#F44336")]:
        ax.bar(counts.index, counts[status], bottom=bottom, color=colour, label=status)
        bottom = bottom + counts[status]
    for i, k in enumerate(counts.index):
        ax.text(i, counts.loc[k].sum(), f"{pct.loc[k, 'DNA']:.1f}%", ha="center", va="bottom", fontsize=8)
    ax.set_title(title)
    ax.set_ylabel("Appointments")
    ax.tick_params(axis="x", rotation=30)
    ax.legend()
    save(fig, name)


def main():
    ar = load_ar()
    s = known(ar, "appointment_status").groupby("appointment_status").count_of_appointments.sum()
    print(f"Overall: {s['Attended'] / s.sum() * 100:.1f}% attended, {s['DNA'] / s.sum() * 100:.1f}% DNA "
          "(Attended and DNA only)\n")

    for var, fig_no, order in [("appointment_mode", "4.1", None), ("hcp_type", "4.2", None),
                               ("time_between_book_and_appointment", "4.3", LEAD_TIME_ORDER)]:
        counts, pct = shares(known(ar, "appointment_status", var), var, "appointment_status")
        if order:
            counts, pct = counts.reindex(order), pct.reindex(order)
        print(f"Fig {fig_no}: status by {var}")
        print(pct.round(1).to_string(), "\n")
        stacked(pct, counts, f"Attendance by {var}", f"fig{fig_no.replace('.', '_')}_status_by_{var}.png")

    counts, pct = shares(known(ar, "appointment_status"), "appointment_month", "appointment_status")
    print("Fig 4.4: by month")
    print(f"  attendance ranges {pct.Attended.min():.1f}% to {pct.Attended.max():.1f}%; "
          f"DNA {pct.DNA.min():.1f}% to {pct.DNA.max():.1f}%")
    low = counts.sum(axis=1).nsmallest(2)
    print(f"  lowest volumes: {', '.join(f'{m} ({v / 1e6:.1f}M)' for m, v in low.items())} (the first COVID-19 lockdown)")
    fig, ax = plt.subplots(figsize=(10, 4.5))
    ax.plot(counts.index, counts.Attended, marker="o", label="Attended")
    ax.plot(counts.index, counts.DNA, marker="o", label="DNA")
    ax2 = ax.twinx()
    ax2.plot(counts.index, pct.DNA, color="grey", linestyle="--", label="DNA %")
    ax2.set_ylabel("DNA %")
    ax.set_title("Monthly appointments by status")
    ax.tick_params(axis="x", rotation=90)
    ax.legend(loc="upper left")
    save(fig, "fig4_4_status_by_month.png")

    print("\nWhat this shows: attendance is high everywhere, but missed appointments are not random. They are\n"
          "lowest for telephone appointments (2.0%) and for GPs (2.6%), and they rise steadily with booking\n"
          "lead time: from 1.8% for same-day appointments to 10.9% for those booked more than 28 days ahead.\n"
          "That gradient is the basis of the report's reminder and scheduling recommendations.")


if __name__ == "__main__":
    main()
