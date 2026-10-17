"""01. Loading and exploring the three NHS datasets (report section 1; notebook section A).

Loads appointments_regional (ar), actual_duration (ad) and national_categories
(nc), then reports what the report's first section inspected: shapes, missing
values, the period each file covers, and how appointments split across the
categorical fields. The fourth dataset, tweets, is covered in example 07.

    python 01_data_overview.py
"""

from common import load_ad, load_ar, load_nc, millions


DERIVED = ["appointment_month_fr", "appointment_date_fr", "appointment_quarter"]


def describe(name, df, period_col, categorical, derived=()):
    raw = df.drop(columns=[c for c in DERIVED + list(derived) if c in df])
    print(f"\n=== {name} ===")
    print(f"{raw.shape[0]:,} rows, {raw.shape[1]} columns; missing values: {int(raw.isna().sum().sum())}")
    print(f"Period: {df[period_col].min()} to {df[period_col].max()}; "
          f"ICBs: {df.icb_ons_code.nunique()}; appointments: {millions(df.count_of_appointments.sum())}")
    for c in categorical:
        s = df.groupby(c).count_of_appointments.sum().sort_values(ascending=False)
        pct = (s / s.sum() * 100).round(1)
        print(f"\n  {c}:")
        for k in s.index:
            print(f"    {k:<62} {millions(s[k]):>9}  {pct[k]:>5.1f}%")


def main():
    ar, ad, nc = load_ar(), load_ad(), load_nc()
    describe("appointments_regional (ar): monthly, by ICB", ar, "appointment_month",
             ["appointment_status", "hcp_type", "appointment_mode", "time_between_book_and_appointment"])
    describe("actual_duration (ad): daily, by sub-ICB location", ad, "appointment_month", ["actual_duration"],
             derived=["appointment_month"])
    describe("national_categories (nc): daily, by sub-ICB location", nc, "appointment_month",
             ["service_setting", "context_type", "national_category"])

    print("\nWhat this shows: the files are complete (no missing values), but each covers a different period,\n"
          "so they cannot simply be added together: ar runs 30 months from January 2020, nc 11 months from\n"
          "August 2021, and ad 7 months from December 2021. Missing information is instead hidden in labels\n"
          "such as 'Unknown', 'Unknown / Data Quality' and 'Unmapped'. Those labels are large for duration\n"
          "(24% of appointments), so the analysis filters them out before computing any percentage.")


if __name__ == "__main__":
    main()
