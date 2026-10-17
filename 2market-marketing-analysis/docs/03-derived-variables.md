# 3. Derived variables: turning fields into segments

*Report section A (Data Manipulation). Example: [`02_derived_variables.py`](../examples/02_derived_variables.py), [`sql/02_derived_variables.sql`](../examples/sql/02_derived_variables.sql).*

Raw fields such as birth year or days since last purchase are hard to act on.
Each derived variable turns one into a segment that marketing can target.

| # | Variable | Built from | Groups | Customers | Tool |
|---|---|---|---|---|---|
| 1 | Age, Age Bucket | Year_Birth | 27–45 · 45–65 · 66 + | 548 · 1,208 · 460 | SQL |
| 2 | Income Bucket | Income percentiles | Low (≤ 37th) · Middle (≤ 66th) · High | 821 · 641 · 754 | SQL |
| 3 | Child_Type, No_Kids | Kidhome, Teenhome | Kid · Teen · Kid & Teen · No child | 514 · 650 · 419 · 633 | Excel |
| 4 | Recent Response | Response, Complain | Positive · Negative · No response | 330 · 3 · 1,883 | Excel |
| 5 | Marketing conversion bucket ("propensity") | Count_success | Hard-to-convert (0) · On-the-fence (1–2) · Ready-to-buy (3+) | 1,757 · 404 · 55 | Excel, then Tableau |
| 6 | Count | — | 1 per row, for totals in Tableau | | Excel |
| 7 | Country | Country code | Eight country names | | Excel |
| 8 | Recency Bucket | Recency | Engaged (0–14 days) · At-risk (15–45) · Lapsing (45+) | 353 · 653 · 1,210 | Excel |

## Choices worth noting

**Age is fixed to the analysis date.** The original query used
`CURRENT_DATE`, so ages, and the buckets built on them, would shift every
year the query is rerun. The example fixes the date to September 2024, when
the report was written, which reproduces its ages (born 1970 → 54).

**Income on percentiles, not fixed amounts.** The working SQL file buckets
income at fixed cut-offs (up to 15,000 low, up to 40,000 middle).
With this customer base that puts two-thirds of customers (1,484) in "High
Income" and only 52 in "Low". The report's version cuts at the **37th and
66th percentiles** (42,523 and 62,769), giving three groups of similar size
that can actually be compared.

**Propensity is defined by advertising conversions.** `Count_success` is the
sum of the five ad conversions (see [2](02-sql-preparation-and-checks.md)).
So "propensity" means past response to ads, and any comparison of ad
conversions across propensity groups partly restates the definition. The
**independent** test of propensity is the response to the *recent*
campaign, which is not part of the definition. That test is in
[7](07-propensity-and-recency.md).

**The groups are very uneven.** 79% of customers have never converted through
an ad, and 55% have not bought anything for more than 45 days. Both facts
shape every chart that counts customers.

**Montenegro, not Middle East.** The report lists the code `ME` as Middle
East. The metadata and the dashboard both have Montenegro, which the example
uses. Only 3 customers are affected.
