"""06. Propensity and purchase recency (dashboard section 4; report insights C-D).

Propensity groups come from past lead conversions (0 / 1-2 / 3+); recency
groups from days since the last purchase (0-14 / 15-45 / 45+). This example
reproduces the dashboard's donut charts (recent campaign response within each
propensity group), then tests the report's four claims about propensity and
recency with per-customer rates.

    python 06_propensity_and_recency.py
"""

import matplotlib.pyplot as plt

from common import prepared, run, save


def main():
    con = prepared()

    print("Donut 'Recent Marketing Response by Customer Propensity Groups':")
    print("(the dashboard counts complaints as Negative whether or not the customer responded; that version is shown)")
    run(con, """
        SELECT "Propensity", count(*) AS customers,
               count(*) FILTER (WHERE "Response" = 1) AS "Positive Response",
               count(*) FILTER (WHERE "Response" = 0 AND "Complain" = 1) AS "Negative Response",
               count(*) FILTER (WHERE "Response" = 0 AND "Complain" = 0) AS "No Response",
               round(100.0 * avg("Response"), 1) AS "response %"
        FROM customers GROUP BY 1 ORDER BY 2 DESC
    """)

    print("Behaviour per customer by propensity group:")
    run(con, """
        SELECT "Propensity", count(*) AS customers, round(100.0 * count(*) / 2216, 1) AS "% of customers",
               round(100.0 * sum("Purchases") / (SELECT sum("Purchases") FROM customers), 1) AS "% of purchases",
               round(avg("Total Spend")) AS "spend/cust", round(avg("Purchases"), 1) AS "purchases/cust",
               round(avg("NumVisits"), 1) AS "web visits/cust", sum("Complain") AS complaints
        FROM customers GROUP BY 1 ORDER BY 2 DESC
    """)

    print("Recency groups: response and propensity mix:")
    rec = run(con, """
        SELECT "Recency Bucket", count(*) AS customers,
               round(100.0 * avg("Response"), 1) AS "response %",
               round(100.0 * avg(CASE WHEN "Propensity" = 'Hard-to-convert' THEN 1 ELSE 0 END), 1) AS "% hard-to-convert",
               round(100.0 * avg(CASE WHEN "Propensity" = 'Ready-to-buy' THEN 1 ELSE 0 END), 1) AS "% ready-to-buy",
               round(avg("Total Spend")) AS "spend/cust", round(avg("Purchases"), 1) AS "purchases/cust"
        FROM customers GROUP BY 1 ORDER BY 3 DESC
    """)[0]

    print("Response rate by propensity within each recency group:")
    grid = run(con, """
        PIVOT (SELECT "Recency Bucket", "Propensity", "Response" FROM customers)
        ON "Propensity" USING round(100.0 * avg("Response"), 1) ORDER BY "Recency Bucket"
    """)[0]

    fig, ax = plt.subplots(figsize=(7, 3.8))
    g = grid.set_index("Recency Bucket").loc[["Engaged", "At-risk", "Lapsing"]]
    g[["Hard-to-convert", "On-the-fence", "Ready-to-buy"]].plot(kind="bar", ax=ax, colormap="Blues")
    ax.set_ylabel("% responded to the recent campaign")
    ax.set_title("Campaign response by recency and propensity")
    ax.tick_params(axis="x", rotation=0)
    save(fig, "response_by_recency_and_propensity.png")

    print("\nWhat this shows, claim by claim:\n"
          "  - 'Lower-propensity customers show significant engagement and purchasing': in total, yes, since\n"
          "    they are 79% of customers and make 76% of purchases; per customer they spend less than half\n"
          "    as much as on-the-fence customers, though they visit the website most.\n"
          "  - 'The campaign was moderately successful for on-the-fence customers': 35% responded (142 of\n"
          "    404) against 8% of the hard-to-convert; the report's '~50%' reads high. Among engaged\n"
          "    on-the-fence customers it reaches 68%.\n"
          "  - 'Only a few purchase-ready customers declined': 10 of 55 (18%).\n"
          "  - 'Lapsing customers are mostly low-propensity and respond poorly': they respond least (9.4%\n"
          "    vs 30.0% for engaged), but their propensity mix is the same as everyone's (80% hard-to-\n"
          "    convert vs 79% overall). Recency, not propensity, is what separates them.\n"
          "  - 'Previously engaged customers are disengaging': the ready-to-buy share is the same 2.3-2.6%\n"
          "    in every recency group, so this snapshot cannot show a shift; that needs purchase history.\n"
          "A caution on direction: Response records whether the customer accepted the last campaign's\n"
          "offer, which probably meant buying something, so responders are likely to be recent buyers\n"
          "for that reason alone. Recency and response are linked, but this data cannot say which\n"
          "drives which.")


if __name__ == "__main__":
    main()
