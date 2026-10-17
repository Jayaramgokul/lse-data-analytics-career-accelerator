"""05. Review sentiment with TextBlob (notebook week 4; report section 3.3).

Prepares the review and summary text (lower case, punctuation removed, duplicates
dropped), scores each with TextBlob polarity (-1 to +1), labels it positive or
negative beyond +/-0.05, compares reviews with summaries, and draws a word cloud of
the most negative reviews after removing stopwords.

    python 05_review_sentiment.py
"""

import re

import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt  # noqa: E402
import nltk  # noqa: E402
from nltk.corpus import stopwords  # noqa: E402
from textblob import TextBlob  # noqa: E402
from wordcloud import WordCloud  # noqa: E402

from common import load_clean, save  # noqa: E402


def clean(text: str) -> str:
    return re.sub(r"[^\w\s]", "", str(text).lower())


def label(p: float) -> str:
    return "positive" if p > 0.05 else "negative" if p < -0.05 else "neutral"


def main():
    nltk.download("stopwords", quiet=True)
    d = load_clean()
    out = {}
    for col in ["review", "summary"]:
        s = d[col].map(clean).drop_duplicates()
        pol = s.map(lambda t: TextBlob(t).sentiment.polarity)
        out[col] = (s, pol)
        share = pol.map(label).value_counts(normalize=True).reindex(["positive", "neutral", "negative"]).fillna(0)
        print(f"{ {'review': 'reviews', 'summary': 'summaries'}[col]:9s} {len(s):5,} unique   mean polarity {pol.mean():+.3f}   "
              + "   ".join(f"{k} {v:.0%}" for k, v in share.items()))

    reviews, pol = out["review"]
    worst = reviews.loc[pol.nsmallest(20).index]
    stop = set(stopwords.words("english"))
    words = " ".join(w for t in worst for w in t.split() if w not in stop and not w.isdigit())
    fig, ax = plt.subplots(figsize=(7, 3.5))
    ax.imshow(WordCloud(background_color="white", width=900, height=450, random_state=42).generate(words))
    ax.axis("off")
    ax.set_title("20 most negative reviews", fontsize=10)
    print(f"\nChart: {save(fig, '05_negative_review_wordcloud')}")
    print("\nWhat this shows: sentiment is mostly positive. Summaries are short, often trailing off in an\n"
          "ellipsis, so more of them score neutral; the full reviews carry more signal. TextBlob scores words,\n"
          "not intent, so sarcasm and negation slip through, which is why the report treats it as a reference\n"
          "point and suggests VADER or a transformer model next.")


if __name__ == "__main__":
    main()
