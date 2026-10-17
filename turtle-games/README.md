# Turtle Games: customer analytics for sales improvement

**LSE Data Analytics Career Accelerator, Course 3 (DA301: Advanced Analytics for Organisational Impact), January 2026.**
Python and R. Regression, decision trees, k-means clustering and NLP sentiment.

> What drives customers' loyalty points? How should customers be segmented for
> marketing? And what do their reviews say about satisfaction and churn risk?

📄 **[Read the report](report/Turtle_Games_Report_Gokulan_DA301.pdf)** ·
[Python notebook as submitted](code/original/turtle_games_python_notebook.ipynb) ·
[R script as submitted](code/original/turtle_games_r_script.R)

## The reasoning, section by section

| | Document | Example |
|---|---|---|
| 1 | [Business objectives, data and preparation](docs/01-objectives-and-data.md) | [py](examples/01_data_preparation.py) |
| 2 | [Linear regression in Python: one predictor at a time, then all three](docs/02-linear-regression-python.md) | [py](examples/02_linear_regression.py) |
| 3 | [Decision tree: cross-validated tuning, bootstrap and permutation importance](docs/03-decision-tree.md) | [py](examples/03_decision_tree.py) |
| 4 | [Customer segmentation with k-means: elbow and silhouette, five segments](docs/04-kmeans-clustering.md) | [py](examples/04_kmeans_clustering.py) |
| 5 | [Review sentiment with TextBlob](docs/05-review-sentiment.md) | [py](examples/05_review_sentiment.py) |
| 6 | [Exploratory analysis in R: bands, groupings, plots](docs/06-r-exploration.md) | [R](examples/06_r_exploration.R) |
| 7 | [Multiple linear regression in R: diagnostics and alternatives](docs/07-r-regression.md) | [R](examples/07_r_regression.R) |
| 8 | [Insights and recommendations: segments × sentiment](docs/08-insights-and-recommendations.md) | [py](examples/08_segments_and_sentiment.py) |

## Main findings

- **Loyalty points** are driven by spending score and remuneration almost
  equally. Age adds little, and the relationship is not linear.
- **Model comparison:** the tuned **decision tree** reaches test R² 0.969,
  against 0.851 for the best linear model (MLR with age²).
- **Segments:** **five** remuneration × spending segments, chosen by the
  elbow and silhouette methods. High earners who spend little are the clearest
  growth opportunity; low earners who spend heavily and review negatively are
  the main churn risk.
- **Sentiment:** reviews are mostly positive (74%). Summaries are too short to
  rely on, and TextBlob misses sarcasm, so a stronger model is recommended
  next.

## Running the examples

The examples run on the course dataset in [`data/`](data/), included with the
permission of LSE and FourthRev. They reproduce the report's figures. From
`examples/`:

```bash
python 01_data_preparation.py      # ... 02-05 and 08 (Python)
Rscript 07_r_regression.R          # 06-07 (R)
```
