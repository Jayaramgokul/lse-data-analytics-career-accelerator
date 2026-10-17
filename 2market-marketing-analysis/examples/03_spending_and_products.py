"""03. What customers buy, and who buys it (report section A; dashboard "Purchasing Behaviour").

Runs the original SQL queries from code/original/cleaning_up.sql unchanged:
total expenditure per country and per product, and the most popular and
second most popular product for each segment (the nested GREATEST / CASE
logic). They run on the joined table, which has the derived buckets they
refer to. Then reproduces the dashboard's "High Demand Consumables" shares.

    python 03_spending_and_products.py
"""

import matplotlib.pyplot as plt

from common import AMOUNTS, PRODUCT_NAMES, original_section, prepared, run, save


def original(title, table_from="marketing_data"):
    """An original query, pointed at the joined table that carries the derived columns."""
    return original_section(title).replace(f"FROM {table_from}", "FROM customers")


def main():
    con = prepared()

    print("Original query: Total Expenditure per Country")
    run(con, original("Total Expenditure per Country") + ' ORDER BY 2 DESC')

    print("Original query: Total Expenditure per Product")
    run(con, original("Total Expenditure per Product"))

    for title in ["Most Popular Product by Country", "Most Popular Product by Marital Status",
                  "Most Popular Product by Education", "Most Popular Product by Age Bucket",
                  "Most Popular & 2nd Most Product by Income Bucket"]:
        print(f"Original query: {title}")
        run(con, original(title))

    shares = con.execute("SELECT " + ", ".join(f'sum("{a}") AS "{a}"' for a in AMOUNTS) + " FROM customers").df().iloc[0]
    shares = (shares / shares.sum() * 100).sort_values(ascending=False)
    print("Dashboard 'High Demand Consumables' (share of all spending):")
    for k, v in shares.items():
        print(f"  {PRODUCT_NAMES[k]:<20} {v:5.2f}%")
    fig, ax = plt.subplots(figsize=(7, 3.5))
    ax.barh([PRODUCT_NAMES[k] for k in shares.index][::-1], shares.values[::-1], color="#2b5c8a")
    ax.set_xlabel("% of total spending")
    ax.set_title("Share of spending by product")
    save(fig, "spending_by_product.png")

    print("\nSpending per customer, by segment:")
    for col in ["Income Bucket", "Child_Type", "Age Bucket", "Education"]:
        run(con, f'SELECT "{col}", count(*) AS "customers", round(avg("Total Spend")) AS "avg spend", '
                 f'round(100.0 * sum("AmtLiq") / sum("Total Spend"), 1) AS "% on beverages" '
                 f'FROM customers GROUP BY 1 ORDER BY 3 DESC')

    print("What this shows: alcoholic beverages are half of all spending (50.3%) and meat items another\n"
          "quarter (27.5%). The original queries find the same ranking (beverages first, meat second) in\n"
          "every country, age band and income band, with two small exceptions: 'Basic' education (54\n"
          "customers, commodities first) and the 3 'Alone' customers (commodities second). Spending per\n"
          "customer is where segments really differ: high-income customers spend twelve times as much as\n"
          "low-income ones, and households without children five to six times as much as those with\n"
          "young children.")


if __name__ == "__main__":
    main()
