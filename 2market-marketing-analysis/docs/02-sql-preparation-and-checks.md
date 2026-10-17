# 2. Preparing and checking the data in SQL

*Report sections B (Data Preprocessing) and C (Data Integration). Original SQL: [`code/original/cleaning_up.sql`](../code/original/cleaning_up.sql). Example: [`01_data_checks.py`](../examples/01_data_checks.py), [`sql/01_checks.sql`](../examples/sql/01_checks.sql).*

## The steps in the report

1. **Trim leading and trailing spaces** in the text columns (education,
   marital status, country, ID), writing the results into new `_clean`
   tables.
2. **Check the primary key for duplicates:** `GROUP BY "ID" HAVING
   count(*) > 1`.
3. **Validate dates:** extract the distinct years, months and days of
   `Dt_Customer` and check that each is in range.
4. **List distinct values** of the categorical columns, to spot typos and odd
   categories.
5. **Join** the two tables with an inner join on `ID`.

## What the checks find

| Check | Result |
|---|---|
| Rows / distinct IDs | 2,216 / 2,216 in both tables |
| Values changed by trimming | 0 |
| Duplicate IDs | None |
| Registration dates | 30 July 2012 – 29 June 2014; all years, months and days valid |
| Rows lost in the join | None |
| `Count_success` vs the ad table's total | Equal for every customer |

The last row matters for interpretation. **`Count_success` is simply the total
of the five advertising conversions**, so the propensity groups built on it in
[3](03-derived-variables.md) are defined by advertising response.

## Details found on re-running the SQL

- **The `_clean` tables.** The trimming step inserted only the four trimmed
  columns into `marketing_data_clean`, and only `ID` into `ad_data_clean`.
  Every other column in those tables stayed empty, so a join on the clean
  tables would carry no spending or ad data. Trimming changed nothing here,
  so the analysis itself was unaffected. The example carries every column
  over (`SELECT * REPLACE (TRIM(...))`).
- **Duplicates the ID check cannot see.** 47 customers repeat another
  customer in every field except the ID: same birth year, income, spending,
  purchases and responses. These are probably the same people registered
  twice. A check over all columns except the ID finds them; the ID check
  cannot.
- **Implausible values.** The distinct-value checks surface more problems:
  - three birth years from 1894 to 1901 (ages 123–130);
  - one income of 666,666;
  - seven joke or rare marital statuses ("YOLO", "Absurd", "Alone").

  They are too few to change any total. But they land in the "66 +" and
  high-income buckets, so a rerun should drop them.

None of these changes the report's conclusions. They are the kind of thing a
second pass over the data should catch.
