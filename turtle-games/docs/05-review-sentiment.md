# 5. Review sentiment

*Report section 3.3. Notebook week 4. Example: [`05_review_sentiment.py`](../examples/05_review_sentiment.py).*

## Preparing the text

Reviews and summaries were handled separately from the numeric data:

1. Lower case and punctuation removed, in both columns.
2. Duplicate texts dropped, so a repeated review is not counted twice.
3. Tokenised. Word clouds drawn before and after removing stopwords and
   alphanumeric tokens.
4. Frequency distribution of the 15 most common words.
5. For the most negative and most positive texts, **lemmatised** so that
   *disappointed* and *disappointing* count as one word.

## Scoring

Each review and summary was scored with **TextBlob polarity**, from −1 (most
negative) to +1 (most positive), and plotted as 15-bin histograms. Scores
were labelled positive above +0.05, negative below −0.05, and neutral in
between.

| Text | Unique texts | Mean polarity | Positive | Neutral | Negative |
|---|---|---|---|---|---|
| Reviews | 1,950 | +0.21 | 74% | 15% | 11% |
| Summaries | 1,351 | +0.27 | 65% | 25% | 11% |

The top 20 positive and negative reviews and summaries were listed and given
their own word clouds. Sentiment was then broken down by remuneration, age
and spending bands.

## What the report concluded

- **Mostly positive:** sentiment is mostly positive across both reviews and
  summaries.
- **Summaries are less informative.** Many end in an ellipsis and are too
  short to carry sentiment, so a quarter score neutral. The full reviews are
  more reliable.
- **TextBlob is a weak instrument.** It scores words, not intent, and often
  misreads rhetoric, sarcasm and negation, as the negative-review word cloud
  shows. The report treats its scores as a reference point, not a measurement.
- **Next step:** check against a labelled sample and try a stronger model,
  such as VADER or a transformer.
