# 8. Insights and recommendations

*Report sections 6–7. Example: [`08_segments_and_sentiment.py`](../examples/08_segments_and_sentiment.py).*

## Insights

- **Loyalty points:** they are skewed, and best explained by spending score
  and remuneration, with age adding a little. The relationship is not linear,
  so the tuned decision tree predicts far better than any linear model.
- **Segments:** five remuneration–spending segments point to acquisition
  opportunities and clear retention priorities for high-value customers.
- **Sentiment:** mostly positive, but negative reviews signal possible churn.
  Summary sentiment should be read with care, since the texts are short and
  TextBlob misses sarcasm and rhetoric.

## Recommendations

### 1. Combine segments with sentiment

Act on each combination, and track conversion and retention to check the
actions work, recalibrating monthly or quarterly.

| Remuneration | Spending | Sentiment | Action |
|---|---|---|---|
| High | Low | Negative | Survey pain points; review which product features lose customers; revise product lines and campaigns |
| High | Low | Neutral or positive | Extend campaigns to help products reach these customers |
| Low | High | Negative | At risk of churn: immediate marketing intervention and offers |
| Low | High | Neutral or positive | Retention-oriented campaigns and offers |

Secondary attention:
- **Low–low:** a smaller re-engagement programme.
- **Mid–mid:** steady growth, watching preferences.
- **High–high:** premium retention rewards.

### 2. Use the tree model

Use it to predict or check loyalty points within each segment, and use its
leaf thresholds to target actions. Because the errors are heteroskedastic,
retrain as needed.

## Limitations the report named

- **Clustering:** k-means assumes round clusters, so validate with another
  method.
- **Sentiment:** TextBlob struggles with sarcasm and negation. Validate on a
  labelled sample and consider VADER or a transformer model.
- **The tree:** single trees have high variance. Random forests or gradient
  boosting could be more stable, if interpretability allows.

## The example

The script crosses the k-means segments with review sentiment and attaches the
recommended action to each group, with its size. For example, **30
low-earning, high-spending customers with negative reviews** are the
immediate churn risk, and **246 high earners who spend little but review
positively** are the clearest growth opportunity.
