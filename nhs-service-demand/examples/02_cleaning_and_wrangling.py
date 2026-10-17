"""02. Cleaning and wrangling for visualisation (report sections 2-3; notebook section B).

Two steps from the report:
  * dates: appointment_month to a datetime, plus quarter (ar); appointment_date
    to a datetime, plus month and quarter (ad). Done in common.py.
  * the five-step pattern of Table 3.1, used for nearly every chart: filter out
    unknown labels, group by two categorical variables, total per level of the
    baseline variable, compute percentages, pivot for a stacked chart.

The output reproduces the report's Figs 3.1-3.4.

    python 02_cleaning_and_wrangling.py
"""

import pandas as pd

from common import known, load_ad, load_ar


def main():
    ar, ad = load_ar(), load_ad()
    print("Dates converted:")
    print(ar[["appointment_month", "appointment_month_fr", "appointment_quarter"]].drop_duplicates().head(3).to_string(index=False))
    print(ad[["appointment_date", "appointment_date_fr", "appointment_month", "appointment_quarter"]].head(3).to_string(index=False))

    pd.set_option("display.float_format", "{:,.2f}".format)
    for baseline in ["appointment_mode", "hcp_type"]:
        # 1. filter unknown labels; status keeps only Attended and DNA
        d = known(ar, "appointment_status", baseline)
        # 2. group by the two variables
        g = d.groupby([baseline, "appointment_status"], as_index=False)["count_of_appointments"].sum()
        # 3. total per level of the baseline variable
        g["total"] = g.groupby(baseline)["count_of_appointments"].transform("sum")
        # 4. percentage within each level
        g["percentage"] = g["count_of_appointments"] / g["total"] * 100
        print(f"\nGroup by {baseline} and status (Fig 3.1 / 3.3):")
        print(g.to_string(index=False))
        # 5. pivot for a stacked bar chart
        print(f"\nPivot (Fig 3.2 / 3.4):")
        print(g.pivot(index=baseline, columns="appointment_status", values=["count_of_appointments", "percentage"]).to_string())

    print("\nWhat this shows: every comparison in the report is a share within a group (for example, the\n"
          "percentage of telephone appointments that were missed), not a raw count. Raw counts would mostly\n"
          "reflect how large each group is: face-to-face has 120 times the appointments of video/online.\n"
          "Filtering 'Unknown' first keeps the shares about the cases where the outcome is actually known.")


if __name__ == "__main__":
    main()
