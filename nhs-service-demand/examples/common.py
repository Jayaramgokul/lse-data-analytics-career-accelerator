"""Shared loading and helpers for the NHS examples."""
from pathlib import Path

import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt
import pandas as pd

HERE = Path(__file__).resolve().parent
DATA = HERE.parent / "data"
OUT = HERE / "output"
OUT.mkdir(exist_ok=True)

# The five national categories the analysis focused on. In the submitted
# notebook this filter (nc_filtered) came from a working notebook run in the
# same session; here it is defined explicitly.
MAIN_CATEGORIES = [
    "General Consultation Routine",
    "General Consultation Acute",
    "Clinical Triage",
    "Planned Clinics",
    "Planned Clinical Procedure",
]

# Top and bottom five ICBs by total appointments (appointments_regional).
TOP5 = ["E54000050", "E54000054", "E54000057", "E54000008", "E54000027"]
BOTTOM5 = ["E54000036", "E54000043", "E54000034", "E54000038", "E54000011"]

# Labels that mark missing or unusable values in each column.
UNKNOWN = {
    "appointment_status": ["Unknown"],
    "hcp_type": ["Unknown"],
    "appointment_mode": ["Unknown"],
    "time_between_book_and_appointment": ["Unknown / Data Quality"],
    "actual_duration": ["Unknown / Data Quality"],
    "national_category": ["Inconsistent Mapping", "Unmapped"],
    "service_setting": ["Unmapped"],
}

# Booking lead times in time order. Note the double spaces: they are in the
# data itself, so an order list typed with single spaces matches nothing.
LEAD_TIME_ORDER = [
    "Same Day", "1 Day", "2 to 7 Days", "8  to 14 Days",
    "15  to 21 Days", "22  to 28 Days", "More than 28 Days",
]
DURATION_ORDER = [
    "1-5 Minutes", "6-10 Minutes", "11-15 Minutes", "16-20 Minutes",
    "21-30 Minutes", "31-60 Minutes",
]


def load_ar():
    """appointments_regional: monthly counts by ICB, Jan 2020 - Jun 2022."""
    ar = pd.read_csv(DATA / "appointments_regional.csv.gz")
    ar["appointment_month_fr"] = pd.to_datetime(ar["appointment_month"], format="%Y-%m")
    ar["appointment_quarter"] = ar["appointment_month_fr"].dt.to_period("Q")
    return ar


def load_ad():
    """actual_duration: daily counts by sub-ICB, Dec 2021 - Jun 2022."""
    ad = pd.read_csv(DATA / "actual_duration.csv.gz")
    ad["appointment_date_fr"] = pd.to_datetime(ad["appointment_date"], format="%d-%b-%y")
    ad["appointment_month"] = ad["appointment_date_fr"].dt.to_period("M")
    ad["appointment_quarter"] = ad["appointment_date_fr"].dt.to_period("Q")
    return ad


def load_nc():
    """national_categories: daily counts by sub-ICB, Aug 2021 - Jun 2022."""
    return pd.read_csv(DATA / "national_categories.csv.gz", parse_dates=["appointment_date"])


def known(df, *columns):
    """Drop rows whose value in any of the given columns is an 'unknown' label."""
    for c in columns:
        df = df[~df[c].isin(UNKNOWN[c])]
    return df


def shares(df, row, col):
    """Counts and row percentages of appointments for two categorical variables.

    The pattern behind most of the report's charts: group by both variables,
    total per level of the baseline variable, then each level's percentage.
    """
    counts = df.pivot_table(index=row, columns=col, values="count_of_appointments",
                            aggfunc="sum", observed=True).fillna(0)
    pct = counts.div(counts.sum(axis=1), axis=0) * 100
    return counts, pct


def save(fig, name):
    fig.tight_layout()
    fig.savefig(OUT / name, dpi=120)
    plt.close(fig)
    print(f"  saved output/{name}")


def millions(x):
    return f"{x / 1e6:,.1f}M"
