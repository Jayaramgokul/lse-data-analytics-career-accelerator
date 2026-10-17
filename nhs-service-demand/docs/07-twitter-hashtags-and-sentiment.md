# 7. Healthcare on Twitter: hashtags and sentiment

*Report sections 2–3 (tweets) and Figs 4.26–4.27. Notebook sections B and D (tweets). Example: [`07_tweets.py`](../examples/07_tweets.py).*

## Why tweets

Appointment data shows what the NHS delivers. Social media adds what the public
talks about and how they feel about it, which helps decide where to
communicate and what to promote.

## The pipeline (Table 2.1, Table 3.3)

| Step | What was done | Rows |
|---|---|---|
| Filter | Keep tweets that have hashtags | 1,174 → **1,007** tweets |
| Explode | One row per hashtag, lower-cased and trimmed | 4,243 |
| Date | Posting date taken from the tweet ID, whose upper bits hold a timestamp | |
| Sentiment | Clean text (URLs, mentions, hashtags, non-letters), score with **VADER**: compound ≥ 0.05 positive, ≤ −0.05 negative, else neutral | |
| Keywords | Keep tweets mentioning at least one of 73 NHS and healthcare terms (whole-word regex, including "did not attend", "waiting time", "primary care") | 4,014 |
| Engagement | Total retweets per hashtag; group hashtags into four retweet tiers | 1,455 hashtags |

## Findings

**Most retweeted hashtags (Fig 3.5):** #healthcare (3,190), then #ai (892),
#health (807), #digitalhealth (735) and #healthtech (611).

**Sentiment of #healthcare (Fig 4.26):**
- 486 positive (58%);
- 254 neutral;
- 104 negative.

**By retweet tier:**

| Tier | Hashtags | Positive | Neutral | Negative |
|---|---|---|---|---|
| Highest | 1 | 486 | 254 | 104 (12%) |
| Second (Fig 4.27) | 34 | 171 | 253 | 59 (12%) |
| Third | 30 | 47 | 74 | 11 (8%) |
| Fourth | 30 | 31 | 31 | 7 (10%) |

**Digital-health hashtags lean positive.**
- #telehealth: 18 positive, 4 neutral, 0 negative.
- #digitalhealth: 13 positive, 15 neutral, 0 negative.

**#mentalhealth is the most mixed:** 5 positive, 4 neutral, 4 negative.

## Limits

Two limits matter for how far these findings can be taken:
- **One day.** Every tweet's ID dates it to **7 September 2022**. This is a
  snapshot: there is no trend over time to read.
- **Not only UK.** Many hashtags (#medicare, #medicaid, #medicareforall)
  are about US healthcare. The keyword filter keeps health content, not NHS
  content.

## What it led to (Table 5.3)

- **Enhance patient communication:** use the high-traffic hashtags
  (#healthcare, #health) for service information.
- **Promote digital health services:** build on positive sentiment towards
  #telehealth, #healthtech and #digitalhealth. This supports the
  remote-appointment recommendation in [4](04-staff-mode-and-lead-time.md).
- **Raise awareness of specialised services:** #mentalhealth and
  #ruralhealth have fewer mentions and mixed sentiment.
- **Use public interest in wellness and prevention:** #wellness, #selfcare,
  #vaccination and #publichealth can carry health campaigns.

## About the data in this repository

Tweet text cannot be redistributed under X's terms, so `tweets.csv` is not
included. [`data/tweet_hashtag_summary.csv`](../data/tweet_hashtag_summary.csv)
holds the hashtag-level counts the pipeline produces (rows, retweets,
favourites, and sentiment counts), with no text. With the course file at
`data/tweets.csv`, the example reruns the whole pipeline.
