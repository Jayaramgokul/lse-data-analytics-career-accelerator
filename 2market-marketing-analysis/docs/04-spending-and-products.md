# 4. What customers buy

*Original SQL sections "Total Expenditure …" and "Most Popular Product …". Dashboard: Purchasing Behaviour. Example: [`03_spending_and_products.py`](../examples/03_spending_and_products.py).*

## The SQL

Most of the original SQL file aggregates spending:
- totals per product and country;
- for each segment, the **most popular and second most popular product**.

The second needed some care. SQL has no "second largest of six columns"
function, so the query:
1. finds the largest of the six product totals with `GREATEST`;
2. then, for each possible winner, runs `GREATEST` again over the remaining
   five to find the runner-up.

This is spelled out as nested `CASE` expressions. The example runs these
queries **unchanged** in DuckDB.

## Results

**Share of all spending** (the dashboard's "High Demand Consumables" treemap;
the values match it exactly):

| Product | Share |
|---|---|
| Alcoholic beverages | **50.26%** |
| Meat items | **27.51%** |
| Commodities | 7.24% |
| Fish products | 6.20% |
| Chocolates | 4.45% |
| Vegetables | 4.34% |

**Most and second most popular product by segment.** Beverages then meat in
every country, age band and income band. There are two small exceptions:
- "Basic" education (54 customers), where commodities come first;
- the 3 "Alone" customers, where commodities come second.

The ranking is so uniform that product preference does not distinguish
segments. **The size of the basket does:**

| Segment | Average spend per customer |
|---|---|
| High income | **$1,262** |
| Middle income | $480 |
| Low income | **$105** |
| No children | **$1,105** |
| Teenagers only | $704 |
| Kids and teens | $220 |
| Kids only | **$186** |
| Aged 66 + | $729 |
| Aged 27–45 | $546 |

High-income customers spend twelve times as much as low-income ones.
Households without children spend five to six times as much as those with
young children.

## What follows from this

**Beverages and meat are what 2Market sells.** Promotions and advertising
creative should lead with them for every segment. Where segments differ is in
how much they spend, which points targeting at **high-income and childless
households**.
