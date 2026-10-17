"""04. The dashboard's key metrics and advertising channels (dashboard sections 1-3; report
"Patterns, Trends & Insights" B).

Reproduces the Key Metrics tiles and the advertising views:
  * the five tiles are computed on the 353 Engaged customers (recency 0-14 days),
    which is what the dashboard showed in the presentation;
  * conversions per channel overall, by country (the "Twitter ad" bars), and by
    propensity and recency group (the bubble charts).

    python 04_key_metrics_and_advertising.py
"""

import matplotlib.pyplot as plt

from common import CHANNELS, prepared, run, save


def channel_sums(where=""):
    return ", ".join(f'sum("{c}") AS "{c.replace("_ad", "")}"' for c in CHANNELS)


def main():
    con = prepared()

    print("Key Metrics tiles: all customers vs Engaged customers (the dashboard's values are the second row)")
    run(con, f"""
        SELECT 'All customers' AS "group", count(*) AS "customers",
               sum("Total Spend") AS "Total Expenditure",
               round(100.0 * sum("NumWebBuy") / sum("NumVisits"), 1) AS "Avg. Website Conversion Rate %",
               round(100.0 * avg("Response"), 1) AS "Marketing Conversion Rate %"
        FROM customers
        UNION ALL
        SELECT 'Engaged (recency 0-14 days)', count(*), sum("Total Spend"),
               round(100.0 * sum("NumWebBuy") / sum("NumVisits"), 1), round(100.0 * avg("Response"), 1)
        FROM customers WHERE "Recency Bucket" = 'Engaged'
    """)
    print("Best Advertising Channel tile, Engaged customers (Bulkmail and Twitter tie at 27):")
    run(con, f'SELECT {channel_sums()} FROM customers WHERE "Recency Bucket" = \'Engaged\'')

    print("Conversions by channel, all customers ('Most Effective Advertising Channels' treemap):")
    totals = run(con, f"SELECT {channel_sums()} FROM customers")[0].iloc[0]
    print("  The treemap's percentages (33.0, 32.8, 32.6, 28.6) are in the same 164 : 163 : 162 : 142 ratio.\n")

    print("'Advertising' bars, attribute Twitter ad, by country:")
    run(con, 'SELECT "Country Name", sum("Twitter_ad") AS "Twitter conversions", count(*) AS "customers", '
             'round(100.0 * avg("Twitter_ad"), 1) AS "% converted" FROM customers GROUP BY 1 ORDER BY 2 DESC')

    print("Advertising response by propensity group (bubble chart 'By Conversions'):")
    by_prop = run(con, f'SELECT "Propensity", count(*) AS "customers", {channel_sums()} '
                       f'FROM customers GROUP BY 1 ORDER BY 2 DESC')[0]
    print("Advertising response by recency group (bubble chart 'By Purchase Recency'):")
    run(con, f'SELECT "Recency Bucket", count(*) AS "customers", {channel_sums()} '
             f'FROM customers GROUP BY 1 ORDER BY 2 DESC')

    fig, ax = plt.subplots(figsize=(8, 4))
    by_prop.set_index("Propensity").drop(columns="customers").T.plot(kind="bar", ax=ax, colormap="Blues_r")
    ax.set_ylabel("Lead conversions")
    ax.set_title("Conversions by channel and propensity group")
    ax.tick_params(axis="x", rotation=0)
    save(fig, "channels_by_propensity.png")

    print("\nWhat this shows: Twitter, bulk mail and Instagram are effectively tied overall (164, 163 and 162\n"
          "conversions), with Facebook a little behind and brochures far behind (30). The tie explains why\n"
          "the dashboard's 'Best Advertising Channel' tile reads Bulkmail while the treemap ranks Twitter\n"
          "first: on the Engaged customers behind the tiles, the two tie at 27. The more useful split is\n"
          "by propensity. On-the-fence customers convert most through bulk mail and Twitter, while the\n"
          "ready-to-buy customers convert most through Instagram (53) and Facebook (49) and least through\n"
          "bulk mail (18). The tiles are worth reading with their filter in mind: across all customers,\n"
          "total spending is $1.35M and the campaign response rate 15%, not $210K and 30%.")


if __name__ == "__main__":
    main()
