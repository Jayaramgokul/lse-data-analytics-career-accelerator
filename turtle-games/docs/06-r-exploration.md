# 6. Exploratory analysis in R

*R script, assignment 5. Example: [`06_r_exploration.R`](../examples/06_r_exploration.R).*

## Why R as well

Turtle Games' sales team worked in R, so the brief asked for the exploration
to be redone there. The R analysis started from the cleaned file saved in
Python, so both halves use the same data. The text columns were dropped,
since this part covers only the structured fields.

## What was done

1. **Inspection and quality checks:** structure, duplicates, missing values,
   and categorical fields converted to factors.
2. **Feature engineering:** continuous measures banded into groups the sales
   team can act on:

   | Band | Cut-offs |
   |---|---|
   | Remuneration | Low < £31k ≤ Middle < £55k ≤ High |
   | Spending | Low < 40 ≤ Medium < 60 ≤ High |
   | Age | Young adult 18–31, middle-aged 32–49, senior 50+ |

3. **Grouped summaries:** median and quartiles of loyalty points and spending
   score by product.
4. **Visual EDA:** distributions (histograms, boxplots) of loyalty points,
   spending and remuneration; relationships between them; top and bottom
   products.

## What it shows

| Remuneration band | Low spending | High spending |
|---|---|---|
| Low | 179 | 944 |
| Middle | 715 | 1,529 |
| High | 881 | **3,866** |

*(median loyalty points)*

Loyalty points rise with spending in every remuneration band, but far more
steeply for high earners. The two predictors **interact**: a straight line
that adds their effects cannot capture this. The same finding points to the
non-linear models.

One detail of the banding: 30 customers aged 17 fall below the first age band,
which starts at 18.
