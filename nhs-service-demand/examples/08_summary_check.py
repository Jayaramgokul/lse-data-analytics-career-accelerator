"""08. The report's summary observations, recomputed (report section 5, Table 5.1).

Recomputes every figure in the summary table of observations and prints it next
to the report's wording. Most match. Where the written observation differs from
what the data (and the report's own charts) show, the line is marked "differs".

    python 08_summary_check.py
"""

from common import BOTTOM5, LEAD_TIME_ORDER, MAIN_CATEGORIES, TOP5, known, load_ad, load_ar, load_nc, shares


def rng(s):
    return f"{s.min():.1f}% to {s.max():.1f}%"


def main():
    ar, ad, nc = load_ar(), load_ad(), load_nc()
    ten = TOP5 + BOTTOM5

    def by_icb(df, var, codes=ten):
        return shares(known(df[df.icb_ons_code.isin(codes)], var), "icb_ons_code", var)[1]

    status = by_icb(ar, "appointment_status")
    hcp_top, hcp_bot = by_icb(ar, "hcp_type", TOP5), by_icb(ar, "hcp_type", BOTTOM5)
    mode = by_icb(ar, "appointment_mode")
    lead = by_icb(ar, "time_between_book_and_appointment")[LEAD_TIME_ORDER]
    dur = by_icb(ad, "actual_duration")
    five = nc[nc.national_category.isin(MAIN_CATEGORIES)]
    month_mix = shares(five, "appointment_month", "national_category")[1]
    settings = shares(known(nc, "service_setting"), "appointment_month", "service_setting")[1]
    national_lead = shares(known(ar, "appointment_status", "time_between_book_and_appointment"),
                           "time_between_book_and_appointment", "appointment_status")[1]

    rows = [
        ("High and consistent attendance",
         "94.0%-96.6% attended, DNA below 6%",
         f"attended {rng(status.Attended)}, DNA at most {status.DNA.max():.1f}%", True),
        ("GP dominance",
         "GPs handle 43.8%-56.2% of appointments (top 5)",
         f"GP share {rng(hcp_top.GP)} (43.8% and 56.2% are E54000008's two shares)", False),
        ("Primary appointment modes",
         "over 50% face-to-face, telephone up to 41.2%, home visit and video below 2.1%",
         f"face-to-face {rng(mode['Face-to-Face'])}; telephone up to {mode.Telephone.max():.1f}% "
         f"(E54000034, a bottom-5 ICB; {mode.loc[TOP5, 'Telephone'].max():.1f}% in the top 5); "
         f"home visit and video at most {max(mode['Home Visit'].max(), mode['Video/Online'].max()):.1f}%", True),
        ("Short-duration appointments",
         "1-10 minute slots are over 46% of bookings",
         f"1-10 minutes {rng(dur['1-5 Minutes'] + dur['6-10 Minutes'])} of recorded durations", True),
        ("Booking time affects attendance",
         "same-day bookings are 20.5%-21.8%; DNA rises beyond 28 days",
         f"same-day bookings {rng(lead['Same Day'])} (20.5%-21.8% is the 2-7 day share in the top 5); "
         f"DNA rises from {national_lead.loc['Same Day', 'DNA']:.1f}% (same day) "
         f"to {national_lead.loc['More than 28 Days', 'DNA']:.1f}% (over 28 days)", False),
        ("Balanced staffing with regional variation",
         "GP shares 48.6%-59.7% (bottom 5)",
         f"GP share {rng(hcp_bot.GP)}; the 59.7% is E54000034, which leans on GPs, not other staff", True),
        ("Under-used service settings",
         "PCNs and Extended Access handle a small fraction",
         f"PCN {rng(settings['Primary Care Network'])}, Extended Access {rng(settings['Extended Access Provision'])} "
         "of mapped appointments per month", True),
        ("Routine consultations dominant",
         "40%-45% of monthly appointments; planned services below 15%",
         f"routine {rng(month_mix['General Consultation Routine'])} of the five main categories; "
         f"planned clinical procedures peak at {month_mix['Planned Clinical Procedure'].max():.1f}% (Oct 2021)", False),
    ]

    width = max(len(r[0]) for r in rows)
    for name, report, data, ok in rows:
        print(f"{name:<{width}}  [{'matches' if ok else 'differs'}]")
        print(f"  report: {report}")
        print(f"  data:   {data}\n")

    print("Also in the regional appendix (Fig 5.4): the top-5 lead-time observations name 15-21 days for\n"
          f"what is the same-day share (up to {lead.loc[TOP5, 'Same Day'].max():.1f}% in the top 5, "
          f"{lead.loc[BOTTOM5, 'Same Day'].max():.1f}% in the bottom 5), and Fig 5.5 names 16-20 minutes\n"
          f"for what is the 31-60 minute share ({rng(dur['31-60 Minutes'])}). The charts themselves are correct.")

    print("\nWhat this shows: the report's main observations hold. Attendance is high, GP and face-to-face\n"
          "care dominate, appointments are short, and missed appointments rise with lead time. The\n"
          "differences look like misreadings of stacked charts with many similarly coloured segments.\n"
          "The biggest one matters for the story: same-day booking is not a\n"
          "fifth of appointments but nearly half, in every region. That strengthens the report's\n"
          "recommendation to increase urgent, same-day capacity.")


if __name__ == "__main__":
    main()
