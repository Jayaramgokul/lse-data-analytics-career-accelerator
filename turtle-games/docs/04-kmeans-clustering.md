# 4. Customer segmentation with k-means

*Report section 3.2. Notebook week 3. Example: [`04_kmeans_clustering.py`](../examples/04_kmeans_clustering.py).*

## What was done

Customers were clustered on the two measures marketing can act on, annual
**remuneration** and **spending score**, using k-means (`k-means++`
initialisation, 10 starts). The number of clusters was chosen with two
methods:

- **Elbow:** within-cluster variance (inertia) for k = 2–10, looking for
  where adding a cluster stops helping much.
- **Silhouette:** how much closer each customer is to its own cluster than to
  the next. Higher is better.

## Choosing k

| k | Inertia | Silhouette |
|---|---|---|
| 3 | 1,006,659 | 0.457 |
| 4 | 633,388 | 0.512 |
| **5** | **348,507** | **0.583** |
| 6 | 302,097 | 0.563 |

Inertia falls steeply up to k = 5 and only slowly after it, and the silhouette
peaks at k = 5. Both methods agree, so **k = 5**.

## The five segments

| Segment | Customers | Mean remuneration | Mean spending score | Mean loyalty points |
|---|---|---|---|---|
| Low pay, low spend | 271 | £20.4k | 20 | 275 |
| Low pay, high spend | 269 | £20.4k | 79 | 972 |
| Mid pay, mid spend | 774 | £44.4k | 50 | 1,420 |
| High pay, low spend | 330 | £74.8k | 17 | 912 |
| High pay, high spend | 356 | £73.2k | 82 | 3,988 |

As the report describes:
- Low earners split into low and high spenders.
- High earners split the same way.
- A large middle group sits between them.

High earners who spend heavily hold nearly three times the average loyalty
points of the middle group. **High earners who spend little** are the clearest untapped
opportunity.

## Limitation

k-means assumes roughly round, similar-sized clusters. The report recommends
validating the segments with an alternative method.
