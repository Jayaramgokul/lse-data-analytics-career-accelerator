# 1. The business context and the data

*Report: "Context of Business" and "The Data". Example: [`01_data_checks.py`](../examples/01_data_checks.py).*

## The question

2Market is a global supermarket selling online and in store. It wanted to
understand:
- **who its customers are** (demographics);
- **what they buy** (purchasing preferences);
- **how well its advertising works.**

The goal was to **allocate the advertising budget** to the right customers and
channels, and so increase profit.

## The data

| Table | Rows | Contents |
|---|---|---|
| `marketing_data` | 2,216 customers | Birth year, education, marital status, income, children and teenagers at home, registration date, days since last purchase, spending on six product groups, purchases by channel (web, in store, discount), website visits, response to the last campaign, complaints, country, total lead conversions |
| `ad_data` | 2,216 customers | Whether each customer converted through each of five advertising channels: bulk mail, Twitter, Instagram, Facebook, brochure |

The two tables share a customer `ID`. A **lead conversion** is a contact,
through an ad or mail, that ended in a purchase.

## Further data the report asked for

The report closed its data section by naming what would improve the
analysis:

1. **Product- and brand-level sales**, to find top sellers rather than broad
   product groups.
2. **Conversions split between marketing and advertising**, since the data
   mixes campaign responses with ad conversions.
3. **The cost of each campaign and channel**, so effectiveness can be weighed
   against spend. Without costs, the "best channel" is the one with the most
   conversions, not the best return.

## Tools

The data was prepared in three tools:
- **Excel:** derived columns written as formulas.
- **SQL:** cleaning, checks, aggregations and joins, in PostgreSQL.
- **Tableau:** the dashboard.

This repository runs the SQL in **DuckDB**, which uses the same dialect, so the
original queries run unchanged. The Excel formulas are rewritten as SQL.
