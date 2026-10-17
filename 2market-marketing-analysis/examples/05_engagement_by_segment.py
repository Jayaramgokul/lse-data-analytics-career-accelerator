"""05. Who is most engaged? Counts versus rates (dashboard sections 2-3; report insights A-B).

The dashboard compares segments by counts of customers, purchases and
responses. Counts mix two things: how big a segment is and how its customers
behave. This example puts each segment's share of the Engaged customers next
to its share of all customers, then adds per-customer rates (spend, purchases,
web visits, campaign response) that separate behaviour from size.

    python 05_engagement_by_segment.py
"""

import matplotlib.pyplot as plt

from common import prepared, run, save

SEGMENTS = ["Country Name", "Marital_Status", "Education", "Age Bucket", "Income Bucket", "Child_Type"]


def main():
    con = prepared()

    print("Dashboard 'Engagement Metrics' (all customers):")
    run(con, 'SELECT sum("NumWalkinPur") AS "In-Store Purchases", sum("NumVisits") AS "Website Visits", '
             'sum("NumWebBuy") AS "Web Purchases", sum("NumDeals") AS "Discount Purchases" FROM customers')

    rates = {}
    for seg in SEGMENTS:
        print(f"--- {seg}")
        rates[seg] = run(con, f"""
            SELECT "{seg}" AS segment,
                   count(*) AS customers,
                   round(100.0 * count(*) / 2216, 1) AS "% of all",
                   count(*) FILTER (WHERE "Recency Bucket" = 'Engaged') AS engaged,
                   round(100.0 * count(*) FILTER (WHERE "Recency Bucket" = 'Engaged') / 353, 1) AS "% of engaged",
                   round(avg("Total Spend")) AS "spend/cust",
                   round(avg("Purchases"), 1) AS "purchases/cust",
                   round(avg("NumVisits"), 1) AS "web visits/cust",
                   round(100.0 * avg("Response"), 1) AS "response %"
            FROM customers GROUP BY 1 HAVING count(*) >= 10 ORDER BY customers DESC
        """)[0]

    r = rates["Child_Type"].set_index("segment")
    fig, axes = plt.subplots(1, 2, figsize=(10, 3.8))
    r["% of engaged"].plot(kind="bar", ax=axes[0], color="#2b5c8a", title="Share of engaged customers (%)")
    r["response %"].plot(kind="bar", ax=axes[1], color="#7fa7c9", title="Campaign response rate (%)")
    for ax in axes:
        ax.tick_params(axis="x", rotation=0)
        ax.set_xlabel("")
    save(fig, "child_type_count_vs_rate.png")

    print("What this shows: the 'most engaged' profile in the report (Spanish, married, graduate, aged\n"
          "45-65) is also the largest group in each attribute, and each holds about the same share of\n"
          "engaged customers as of all customers (Spain 49.9% vs 49.3%). So the counts identify the\n"
          "biggest segment, not the most engaged one. Per customer, the differences are clearer:\n"
          "  - high income: 12 times the spend of low income, the most purchases, and double the response;\n"
          "  - single, divorced and widowed customers respond about twice as often as married ones\n"
          "    (21-24% vs 11%), and childless households far more than those with teenagers (26.5% vs 8.2%):\n"
          "    the report's point that singles and childless households responded most holds, and is\n"
          "    stronger as a rate;\n"
          "  - PhD holders respond most by education (21%), and 66+ customers spend most per head.")


if __name__ == "__main__":
    main()
