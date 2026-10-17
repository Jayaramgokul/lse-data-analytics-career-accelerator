# 2. Cleaning and wrangling

*Report sections 2–3. Notebook section B. Example: [`02_cleaning_and_wrangling.py`](../examples/02_cleaning_and_wrangling.py).*

## Cleaning

**Appointment files.** Little cleaning was needed:
- `appointment_month` (ar) was converted to a date, and a quarter column added.
- `appointment_date` (ad) was converted to a date, with month and quarter
  columns added, so the three files can be compared by month.

**Tweets.** These needed more work; see [7](07-twitter-hashtags-and-sentiment.md).

## One pattern behind almost every chart

Nearly every chart compares appointments across **two categorical variables**,
for example mode and status. The report's Table 3.1 sets out five steps:

1. **Filter** out rows labelled "Unknown", "Unmapped" and so on.
2. **Group** by the two variables and sum the appointment counts.
3. **Total** for each level of the baseline variable (for example, all
   face-to-face appointments).
4. **Percentage:** each combination as a share of its level's total.
5. **Pivot:** baseline levels as rows and the second variable as columns,
   ready for a stacked chart.

Applied to mode and status, this gives the report's Fig 3.1–3.2:

| Mode | Attended | DNA | % DNA |
|---|---|---|---|
| Face-to-Face | 392,705,999 | 24,253,038 | 5.8 |
| Home Visit | 3,612,068 | 187,571 | 4.9 |
| Telephone | 254,799,226 | 5,262,251 | 2.0 |
| Video/Online | 3,303,233 | 158,946 | 4.6 |

(DNA means "did not attend": a missed appointment.)

## Why percentages, not counts

Raw counts mostly reflect how big each group is: there are 120 times as many
face-to-face appointments as video ones. A **share within a group** separates
behaviour from size: what fraction of telephone appointments are missed,
compared with face-to-face?

Filtering the unknown labels **before** computing shares keeps each share
about the cases whose outcome is actually known.

Table 3.2 of the report lists every combination analysed:
- **Appointment views:** status, professional type, mode, lead time,
  duration, category and setting, each against the others and against month.
- **Geographic views:** the ICB against each of these.
