# LSE Data Analytics Career Accelerator

![examples](https://github.com/Jayaramgokul/lse-data-analytics-career-accelerator/actions/workflows/examples.yml/badge.svg)
![python](https://img.shields.io/badge/python-3.10%2B-blue)
![R](https://img.shields.io/badge/R-4.x-blue)

**Three course projects from the London School of Economics Data Analytics
Career Accelerator (delivered with FourthRev), 2024–2026.** Each project
answers a business question with real data, moving from spreadsheets and SQL
to Python and R:
- **2Market:** dashboards;
- **NHS:** diagnostic analysis;
- **Turtle Games:** predictive models.

Each project folder holds:
- **the report as submitted**;
- **the original code**;
- **the course data**;
- **a document for each part of the analysis**, explaining what was done and
  why;
- **an example script** that reruns that part on the data and reproduces the
  report's numbers.

## The projects

| | Project | Question | Methods | Tools |
|---|---|---|---|---|
| 1 | [**2Market**: customers, purchases and advertising](2market-marketing-analysis/) | Who are the customers, what do they buy, and which advertising reaches them? | Data cleaning and checks, derived segments, aggregation, dashboard design | Excel, SQL, Tableau |
| 2 | [**NHS**: service demand and utilisation](nhs-service-demand/) | Does general practice have the capacity it needs, and is it used well? | Data wrangling across three datasets, two-way breakdowns, regional comparison, VADER sentiment on tweets | Python (pandas, seaborn, NLTK) |
| 3 | [**Turtle Games**: customer analytics](turtle-games/) | What drives loyalty, how should customers be segmented, and what do reviews say? | Linear regression, decision trees, k-means clustering, TextBlob sentiment | Python, R |

## What each project found

**2Market** (Course 1, September 2024)
- Beverages and meat are three-quarters of spending in nearly every segment.
- High-income, single and childless customers spend and respond most.
- Campaign response falls from 30% to 9% as customers lapse.
- Twitter, bulk mail and Instagram tie as channels, but likely buyers prefer
  Instagram and Facebook.

**NHS** (Course 2, October 2024)
- Missed appointments rise from 1.8% for same-day bookings to 10.9% for
  bookings more than four weeks ahead.
- Same-day demand is nearly half of all appointments. GPs carry most of it.
- The busiest and quietest regions work the same way. They differ in size,
  not practice.

**Turtle Games** (Course 3, January 2026)
- Loyalty points depend on spending score and remuneration, non-linearly.
  A tuned decision tree reaches R² 0.969, against 0.851 for the best linear
  model.
- Five customer segments emerge.
- High earners who spend little are the growth opportunity; low earners who
  spend heavily and review negatively are the churn risk.

## Corrections to the original reports

Each correction is documented where it occurs.

| Project | Correction |
|---|---|
| Turtle Games | A digit transposition in one reported error metric |
| NHS | A label mismatch that left three bars of one chart empty. Several values in the written observations were read off the wrong segment of stacked charts; the most important: same-day booking is nearly half of appointments, not a fifth |
| 2Market | Likely duplicate customers that an ID check cannot see. The dashboard's headline tiles cover only recently active customers, without saying so |

None of these overturns a conclusion, and one (the NHS same-day share)
strengthens a recommendation.

## Running the examples

```bash
pip install -r requirements.txt
cd nhs-service-demand/examples && python 01_data_overview.py   # each project: examples/0*.py
```

- **R:** the Turtle Games R examples need `dplyr`, `ggplot2`, `car`,
  `lmtest` and `Metrics`.
- **CI:** runs every example on Python 3.10 and 3.12, and on R.
- **Data:** the course datasets are included with the permission of LSE and
  FourthRev. Tweet text is not, under X's terms; the NHS project includes
  hashtag-level counts instead.

## Licence

Code is MIT-licensed ([LICENSE](LICENSE)). The reports, dashboard images and
datasets are not covered by the licence.
