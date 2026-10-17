"""02. Derived variables (report section A).

Runs sql/02_derived_variables.sql on the joined table: age and age bucket,
income bucket on percentiles, child type, recent response, propensity
(marketing conversion bucket), country names and recency bucket. Prints how
customers spread across each, and compares the percentile income buckets in
the report with the fixed-threshold version in the working SQL file.

    python 02_derived_variables.py
"""

from common import prepared, run


def main():
    con = prepared()

    run(con, 'SELECT min("Age") AS "youngest", max("Age") AS "oldest", '
             'PERCENTILE_CONT(0.37) WITHIN GROUP (ORDER BY "Income") AS "income p37", '
             'PERCENTILE_CONT(0.66) WITHIN GROUP (ORDER BY "Income") AS "income p66" FROM customers')
    for col in ["Age Bucket", "Income Bucket", "Child_Type", "Recent Response", "Propensity", "Recency Bucket"]:
        run(con, f'SELECT "{col}", count(*) AS "customers", round(100.0 * count(*) / 2216, 1) AS "%" '
                 f'FROM customers GROUP BY 1 ORDER BY 2 DESC')

    print("Income buckets in the working SQL file (fixed thresholds: up to 15,000 low, up to 40,000 middle):")
    run(con, """
        SELECT CASE WHEN "Income" BETWEEN 1730 AND 15000 THEN 'Low Income'
                    WHEN "Income" BETWEEN 15001 AND 40000 THEN 'Middle Income'
                    ELSE 'High Income' END AS "fixed-threshold bucket",
               count(*) AS "customers"
        FROM customers GROUP BY 1 ORDER BY 2 DESC
    """)

    print("What this shows: each derived variable turns a raw field into a segment marketing can act on.\n"
          "The income buckets show why the percentile version in the report beats the fixed thresholds\n"
          "in the working SQL file: with cut-offs at 15,000 and 40,000, two-thirds of customers fall into\n"
          "'High Income'; cutting at the 37th and 66th percentiles (42,523 and 62,769) gives three groups\n"
          "of similar size. Two buckets are very uneven by design: 79% of customers are hard to convert\n"
          "(no lead conversions at all) and 55% have not bought for over 45 days. Those two facts frame\n"
          "the rest of the analysis.")


if __name__ == "__main__":
    main()
