"""01. Loading, checking and joining the two tables (report sections B-C).

Runs sql/01_checks.sql: row counts, trimming, duplicate IDs, registration
dates, distinct category values, and the inner join of marketing_data with
ad_data on ID. Then lists the data-quality issues that the checks surface.

    python 01_data_checks.py
"""

from common import connect, run, run_file


def main():
    con = connect()
    run_file(con, "01_checks.sql")

    print("Data-quality issues worth knowing before any analysis:")
    run(con, """
        SELECT "ID", "Year_Birth", "Income", "Marital_Status"
        FROM customers
        WHERE "Year_Birth" < 1910 OR "Income" > 200000 OR "Marital_Status" IN ('YOLO', 'Absurd', 'Alone')
        ORDER BY "Year_Birth";
    """)

    print("What this shows: the two tables are clean in the structural sense: 2,216 customers each, one\n"
          "row per ID, no stray spaces, registration dates all valid (July 2012 to June 2014), and the join\n"
          "loses no one. Checks beyond structure find more: 47 rows repeat another customer in every field\n"
          "but the ID (likely the same person registered twice), three birth years from 1894 to 1901\n"
          "(ages 123-130), one income of 666,666, and seven rare or joke marital statuses (YOLO, Absurd,\n"
          "Alone). They are too few to move the totals, but they fall into the '66 +' and high-income\n"
          "buckets and inflate counts, so they are worth excluding in a rerun.\n"
          "The ad table's last column equals Count_success for every customer: Count_success is simply\n"
          "the total of the five advertising conversions.")


if __name__ == "__main__":
    main()
