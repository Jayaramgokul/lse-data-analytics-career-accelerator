# 8. Insights and next steps

*Report: "Patterns, Trends & Insights". Presentation: "Conclusion".*

## The report's conclusions, with the evidence behind each

| Report conclusion | Evidence | Holds? |
|---|---|---|
| High-earning, married, Spanish customers aged 45–65 with graduate degrees are the most engaged | They are the largest group in each attribute. Per customer, **high income** stands out (12 times the spend, twice the response of low income); country, age and degree change spend per head little, and married customers respond *less* than single ones | Partly. Counts measure size; high income is the real signal ([6](06-advertising-and-marketing-response.md)) |
| Beverages are the most consumed product, then meat | 50.3% and 27.5% of spending; first and second in nearly every segment | Yes ([4](04-spending-and-products.md)) |
| Singles and childless households respond more to recent marketing | 22.5% (single) and 26.5% (no children) vs 11.4% (married) and 8.2% (teenagers) | Yes, and stronger as a rate |
| Twitter is the best advertising channel overall; high-propensity customers prefer Instagram | 164 vs 163 (bulk mail) vs 162 (Instagram): a three-way tie. Ready-to-buy customers: Instagram 53, Facebook 49, bulk mail 18 | Tie overall; the Instagram point holds |
| Website conversion outruns marketing conversion | 77.8% vs 30% on the tiles (engaged customers) | Different measures, so not a like-for-like comparison |
| Lower-propensity customers show significant engagement and purchasing | 79% of customers, 76% of purchases; half the spend per head of on-the-fence | In total, yes; per customer, no |
| The campaign was moderately successful (~50%) on on-the-fence customers; few ready-to-buy declined | 35% (142 of 404); 68% among engaged ones. 10 of 55 ready-to-buy declined | Yes, at 35% rather than ~50% ([7](07-propensity-and-recency.md)) |
| Lapsing customers, mainly low-propensity, respond poorly | 9.4% vs 30.0% for engaged; same propensity mix as everyone | Yes on response; recency, not propensity, is the driver |
| Previously engaged customers are disengaging | One snapshot; the propensity mix is the same in every recency group | Needs purchase history to test |

## What the analysis supports

1. **Lead with beverages and meat** in promotions, for every segment.
2. **Target high-income, single and childless households.** High-income and
   childless customers spend most per head, and all three respond at 22–27%
   against an average of 15%.
3. **Choose channels by propensity:**
   - Instagram and Facebook for customers likely to buy;
   - bulk mail and Twitter for those on the fence;
   - brochures for neither.
4. **Act on recency.** Response halves at each step from engaged to lapsing,
   so re-engagement campaigns should start within weeks of the last
   purchase, not months.
5. **Rethink marketing to hard-to-convert customers.** They are most of the
   customer base, respond at 8%, and make nearly all the complaints, as the
   report concluded.

## The next steps the report named

- **Product- and brand-level data**, to find top sellers inside "beverages"
  and "meat".
- **Separate marketing from advertising conversions**, which `Count_success`
  combines.
- **Campaign and channel costs**, so channels can be ranked by return, not
  just by conversions. With costs, the three-way tie between Twitter, bulk
  mail and Instagram could be broken.
- **Purchase history over time**, needed to test whether loyal customers are
  really disengaging.

## Data limitations

- **Possible duplicates:** 47 customers duplicate another in every field but
  the ID ([2](02-sql-preparation-and-checks.md)).
- **Implausible values:** a few ages over 120 and one income of 666,666.
- **Unlabelled filter:** the dashboard's key metrics cover only engaged
  customers, without saying so ([5](05-dashboard-design.md)).
- **No time dimension:** every behaviour variable is a total or a single
  value, so the data can show associations but not change over time.
