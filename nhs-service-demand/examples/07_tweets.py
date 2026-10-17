"""07. Healthcare hashtags on Twitter: engagement and sentiment (report Figs 2.1-2.4, 3.5-3.6,
4.26-4.27; notebook sections B and D, tweets).

The pipeline, as in the notebook:
  1. keep tweets that have hashtags;
  2. split and explode the hashtags, one row per hashtag, lower-cased and trimmed;
  3. derive each tweet's posting date from its ID (Twitter "snowflake" IDs);
  4. clean the text (URLs, mentions, hashtags, non-letters) and score it with
     VADER: compound >= 0.05 positive, <= -0.05 negative, otherwise neutral;
  5. keep tweets that mention at least one NHS or healthcare keyword;
  6. total retweets per hashtag, group hashtags into retweet tiers, and count
     sentiment within each tier.

Tweet text cannot be redistributed under X's terms, so tweets.csv is not in
this repository. If you have the course file, put it at data/tweets.csv: the
script then runs the whole pipeline and rewrites the hashtag-level summary.
Without it, the script reads that summary (data/tweet_hashtag_summary.csv),
which holds counts only, no text.

    python 07_tweets.py
"""

import datetime
import json
import re

import matplotlib.pyplot as plt
import pandas as pd
import seaborn as sns

from common import DATA, save

RAW = DATA / "tweets.csv"
SUMMARY = DATA / "tweet_hashtag_summary.csv"
COUNTS = DATA / "tweet_pipeline_counts.json"

KEYWORDS = [
    "nhs", "gp", "bma", "doctor", "medication", "appointment", "appointments", "healthcare", "health",
    "patient", "patients", "consultation", "medicare", "medical",
    "healthcare professional", "practice staff", "missed appointments", "did not attend",
    "resource utilization", "staff adequacy", "budget allocation", "resource allocation",
    "utilisation trends", "no show patient", "waiting time", "appointment reminder", "patient engagement",
    "social impact", "financial impact", "vulnerable communities", "punishing patients",
    "investigate reasons", "data informed decision", "expand capacity", "existing infrastructure",
    "better utilization", "reduce missed appointments", "appointment booking", "appointment management",
    "patient communication", "healthcare access", "service utilization", "reduce no show",
    "increase efficiency", "resource optimization", "staff allocation", "health services", "patient care",
    "medical appointments", "appointment scheduling", "community health", "public health",
    "healthcare system", "medical practice", "primary care", "extended access", "virtual appointment",
    "home visit", "face to face", "telephone consultation", "video consultation", "online consultation",
    "clinical triage", "planned clinic", "medication review", "care encounter", "unplanned activity",
    "care home visit", "social prescribing", "care planning", "chargeable work", "group consultation",
    "group education",
]

# Retweet tiers, as listed in the notebook. Fig 4.26 is the top tier and
# Fig 4.27 the second.
TIERS = {
    "highest": ["#healthcare"],
    "second": [
        "#health", "#healthtech", "#meded", "#medical", "#medicine", "#medtwitter", "#medicare",
        "#telehealth", "#clinicalpearl", "#clinicaltips", "#covid", "#ehealth", "#equitable",
        "#medstudents", "#medstudenttwitter", "#mhealth", "#pharmaceutical", "#coronavirus", "#covid19",
        "#genderaffirmingcare", "#nurses", "#telemedicine", "#transgendercare", "#vaccine", "#doctor",
        "#healthcareit", "#medtech", "#flu", "#hiv", "#pandemic", "#vetcare", "#aids", "#immunization",
        "#influenza",
    ],
    "third": [
        "#lockdown", "#mentalhealth", "#quarantine", "#stayhome", "#vaccination", "#vaccines", "#who",
        "#disparities", "#healthit", "#hipaa", "#hospital", "#medicareforall", "#medtechvision22",
        "#pharmacies", "#publichealth", "#premisehealth", "#cancer", "#cancerawareness",
        "#healthcareprofessionals", "#hospitals", "#medicaid", "#patientexperience", "#qualitypatientcare",
        "#telehealthishealth", "#therapy", "#cardiology", "#nystateofhealth", "#patient", "#patientdata",
        "#patientengagement",
    ],
    "fourth": [
        "#patients", "#physicians", "#psychiatry", "#psychology", "#telemed", "#wellness", "#breastcancer",
        "#drugdiscovery", "#heartfailure", "#medicaldeserts", "#utmhealthcare", "#aiforhealth",
        "#anesthesia", "#diagnostic", "#ruralhealth", "#soteradigitalhealth", "#vitalsignmonitoring",
        "#vitalsigns", "#weltelhealth", "#eyecare", "#eyedisease", "#healthcarecommercialintelligence",
        "#healthcareisahumanright", "#healthoutcomes", "#healthsecurity", "#hivcare", "#rehospitalizations",
        "#sarscov2", "#scrubs", "#selfcare",
    ],
}


def tweet_date(tweet_id):
    """Twitter IDs carry a millisecond timestamp in their upper bits."""
    ms = (int(tweet_id) >> 22) + 1288834974657
    return datetime.datetime.fromtimestamp(ms / 1000, tz=datetime.timezone.utc).date()


def clean(text):
    text = re.sub(r"http\S+|www.\S+", "", text)
    text = re.sub(r"@\w+|#\w+", "", text)
    text = re.sub(r"[^A-Za-z\s]", "", text)
    return text.strip()


def label(compound):
    return "positive" if compound >= 0.05 else ("negative" if compound <= -0.05 else "neutral")


def run_pipeline():
    import nltk
    nltk.download("vader_lexicon", quiet=True)
    from nltk.sentiment.vader import SentimentIntensityAnalyzer
    sia = SentimentIntensityAnalyzer()

    tweets = pd.read_csv(RAW)
    fil = tweets[tweets.tweet_entities_hashtags.notna()].copy()
    fil["hashtags_list"] = fil.tweet_entities_hashtags.str.split(",")
    ex = fil.explode("hashtags_list")
    ex["hashtag"] = ex.hashtags_list.str.lower().str.strip()
    ex["date"] = ex.tweet_id.apply(tweet_date)
    ex["compound"] = ex.tweet_full_text.apply(lambda t: sia.polarity_scores(clean(t))["compound"])
    ex["sentiment"] = ex.compound.apply(label)
    pattern = re.compile("(" + "|".join(r"\b" + re.escape(k) + r"\b" for k in KEYWORDS) + ")", re.IGNORECASE)
    kept = ex[ex.tweet_full_text.str.lower().apply(lambda t: bool(pattern.search(t)))]

    summary = kept.groupby("hashtag").agg(rows=("tweet_id", "size"),
                                          retweets=("tweet_retweet_count", "sum"),
                                          favourites=("tweet_favorite_count", "sum"))
    sentiment = kept.groupby(["hashtag", "sentiment"]).size().unstack(fill_value=0)
    summary = summary.join(sentiment).fillna(0).astype(int).sort_values("retweets", ascending=False)
    summary.to_csv(SUMMARY)
    counts = {
        "tweets": len(tweets),
        "tweets_with_hashtags": len(fil),
        "hashtag_rows": len(ex),
        "hashtag_rows_with_keywords": len(kept),
        "distinct_hashtags": int(kept.hashtag.nunique()),
        "first_date": str(ex.date.min()),
        "last_date": str(ex.date.max()),
    }
    COUNTS.write_text(json.dumps(counts, indent=2) + "\n")
    print(f"Ran the full pipeline on {RAW.name}; wrote {SUMMARY.name} and {COUNTS.name}")
    return summary, counts


def main():
    if RAW.exists():
        summary, counts = run_pipeline()
    else:
        summary = pd.read_csv(SUMMARY, index_col="hashtag")
        counts = json.loads(COUNTS.read_text())
        print(f"{RAW.name} not present (not redistributable); using the hashtag-level summary")

    print(f"\nTweets: {counts['tweets']:,}; with hashtags: {counts['tweets_with_hashtags']:,} "
          f"(Table 2.1); one row per hashtag: {counts['hashtag_rows']:,}; "
          f"mentioning a healthcare keyword: {counts['hashtag_rows_with_keywords']:,}")
    print(f"Posting dates from tweet IDs: {counts['first_date']} to {counts['last_date']}")

    top = summary[summary.retweets > 0].head(8)
    print("\nFig 3.5: most retweeted hashtags")
    print(top[["retweets", "favourites"]].to_string())

    hc = summary.loc["#healthcare", ["negative", "neutral", "positive"]]
    print(f"\nFig 4.26: #healthcare sentiment: {hc.positive} positive, {hc.neutral} neutral, {hc.negative} negative "
          f"({hc.positive / hc.sum() * 100:.0f}% positive)")
    fig, ax = plt.subplots(figsize=(6, 2.5))
    sns.heatmap(hc.to_frame("#healthcare").T, annot=True, fmt="d", cmap="RdYlGn", ax=ax)
    ax.set_title("Sentiment of #healthcare tweets")
    save(fig, "fig4_26_healthcare_sentiment.png")

    print("\nSentiment by retweet tier (rows per hashtag in the tier):")
    for tier, tags in TIERS.items():
        t = summary.reindex([h for h in tags if h in summary.index])[["negative", "neutral", "positive"]].sum()
        print(f"  {tier:<8} {len(tags):>3} hashtags: {t.positive:>4} positive, {t.neutral:>4} neutral, "
              f"{t.negative:>3} negative ({t.negative / t.sum() * 100:.0f}% negative)")

    second = summary.reindex([h for h in TIERS["second"] if h in summary.index])[["negative", "neutral", "positive"]]
    fig, ax = plt.subplots(figsize=(6, 9))
    sns.heatmap(second, annot=True, fmt="d", cmap="RdYlGn", ax=ax, annot_kws={"size": 7})
    ax.set_title("Sentiment, second retweet tier")
    save(fig, "fig4_27_second_tier_sentiment.png")
    for h in ["#telehealth", "#healthtech", "#digitalhealth", "#mentalhealth", "#ruralhealth"]:
        if h in summary.index:
            r = summary.loc[h]
            print(f"  {h:<16} {r.positive:>3} positive, {r.neutral:>3} neutral, {r.negative:>3} negative")

    print("\nWhat this shows: healthcare conversation on Twitter is mostly positive or neutral. Negative\n"
          "tweets are a minority in every retweet tier, and the hashtags about digital and remote care\n"
          "(#healthtech, #telehealth, #digitalhealth) lean positive, which supports offering more remote\n"
          "appointments. Two limits: every tweet in the file was posted on one day, so there is no trend\n"
          "to read; and many of the hashtags (#medicare, #medicaid) are about US rather than UK healthcare.")


if __name__ == "__main__":
    main()
