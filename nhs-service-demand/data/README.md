# Data

Course data for the LSE DA201 assignment, included with the permission of LSE
and FourthRev. The appointment data derives from NHS Digital's (now NHS England's) *Appointments
in General Practice* publication; [`metadata_nhs.txt`](metadata_nhs.txt)
describes every field.

| File | Contents | Note |
|---|---|---|
| `appointments_regional.csv.gz` | Monthly appointments by ICB, Jan 2020 – Jun 2022 | Course CSV, gzip-compressed |
| `actual_duration.csv.gz` | Daily appointments by sub-ICB location and duration, Dec 2021 – Jun 2022 | Course CSV, gzip-compressed |
| `national_categories.csv.gz` | Daily appointments by sub-ICB location, service setting and national category, Aug 2021 – Jun 2022 | Course `national_categories.xlsx`, saved as CSV and compressed. Same 817,394 rows and 296,046,770 appointments |
| `tweet_hashtag_summary.csv` | Per hashtag: rows, retweets, favourites, and negative / neutral / positive counts | Produced by [`07_tweets.py`](../examples/07_tweets.py). Counts only, no tweet text |
| `tweet_pipeline_counts.json` | Row counts at each step of the tweet pipeline, and the posting-date range | Produced by `07_tweets.py` |

pandas reads the `.csv.gz` files directly.

**Tweets.** The course's `tweets.csv` is not included: tweet text cannot be
redistributed under X's terms. If you have it, place it here as
`data/tweets.csv` and `07_tweets.py` will rerun the full pipeline.
