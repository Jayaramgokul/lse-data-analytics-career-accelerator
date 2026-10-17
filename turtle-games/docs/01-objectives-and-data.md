# 1. Business objectives, data and preparation

*Report sections 1–2. Notebook week 1, sections 1–4. Example: [`01_data_preparation.py`](../examples/01_data_preparation.py).*

## The brief

Turtle Games, a game manufacturer and retailer, wanted to improve sales by
using customer data to guide marketing. The report set one main objective and
three supporting ones:

| Objective | Question | Method |
|---|---|---|
| **Main:** improve sales performance through customer analytics | — | — |
| Loyalty-point engagement | What drives loyalty points, and how well can they be predicted? | Linear regression, decision trees ([2](02-linear-regression-python.md), [3](03-decision-tree.md), [7](07-r-regression.md)) |
| Customer segmentation | Which customer groups should marketing target, for acquisition and retention? | k-means clustering ([4](04-kmeans-clustering.md)) |
| Customer sentiment | What do reviews say about satisfaction and churn risk? | NLP with TextBlob ([5](05-review-sentiment.md)) |

## The data

`turtle_reviews.csv`: 2,000 customer reviews, each with the reviewer's
profile ([data dictionary](../data/metadata_turtle_games.txt)).

| Field | Role |
|---|---|
| `loyalty_points` | Target: points earned from purchases and actions |
| `spending_score` (1–100), `remuneration` (k£), `age` | Main numeric predictors |
| `gender`, `education` | Categorical descriptors |
| `product` | Product code |
| `review`, `summary` | Free text for sentiment |
| `language`, `platform` | Constant: every row is "EN" and "Web" |

## Preparation

The report organised the work into three steps.

1. **Two workflows:** numeric and categorical fields for modelling and
   clustering; review and summary text for NLP.
2. **Validation:** checks for missing values and duplicates, and correct data
   types (factors for categories in R).
3. **Text normalisation, for NLP only:** lower case, punctuation removed,
   lemmatisation, alphanumeric tokens and duplicate texts removed.

As the brief required, `language` and `platform` were dropped and the long
column names shortened to `remuneration` and `spending_score`. The cleaned
file was saved and reused, including by the R analysis.

## What the example shows

The data is complete (no missing values, no duplicate rows). The two dropped
columns carry no information. `loyalty_points` is strongly right-skewed
(skewness 1.46): most customers hold modest balances, while a few hold very
high ones. That skew is the first hint that a straight-line model will
struggle.
