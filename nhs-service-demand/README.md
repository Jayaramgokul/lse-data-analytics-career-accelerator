# NHS: service demand and utilisation in general practice

**LSE Data Analytics Career Accelerator, Course 2 (DA201: Data Analytics using Python), October 2024.**
Python: pandas, matplotlib, seaborn; NLTK VADER for sentiment.

> Does general practice in England have enough capacity, and is it using what it
> has well? Where are appointments missed, who delivers which kind of care, and
> what does public conversation about healthcare add?

📄 **[Read the report](report/NHS_Service_Demand_Report_Gokulan_DA201.pdf)** ·
[Python notebook as submitted](code/original/nhs_python_notebook.ipynb)

## The reasoning, section by section

| | Document | Example |
|---|---|---|
| 1 | [The business question and the four datasets](docs/01-business-question-and-data.md) | [py](examples/01_data_overview.py) |
| 2 | [Cleaning, and the five-step pattern behind every chart](docs/02-cleaning-and-wrangling.md) | [py](examples/02_cleaning_and_wrangling.py) |
| 3 | [Attendance and missed appointments](docs/03-attendance-and-missed-appointments.md) | [py](examples/03_attendance.py) |
| 4 | [Who sees patients, how, and how far ahead](docs/04-staff-mode-and-lead-time.md) | [py](examples/04_staff_mode_lead_time.py) |
| 5 | [Appointment length, type and setting](docs/05-duration-and-national-categories.md) | [py](examples/05_duration_and_categories.py) |
| 6 | [The busiest and quietest regions](docs/06-regional-comparison.md) | [py](examples/06_regional_comparison.py) |
| 7 | [Healthcare on Twitter: hashtags and VADER sentiment](docs/07-twitter-hashtags-and-sentiment.md) | [py](examples/07_tweets.py) |
| 8 | [Observations and recommendations, re-checked against the data](docs/08-observations-and-recommendations.md) | [py](examples/08_summary_check.py) |

## Main findings

- **Attendance:** high (95.6%). **Missed appointments rise with booking lead
  time,** from 1.8% for same-day appointments to 10.9% for those booked more
  than 28 days ahead.
- **Same-day demand:** nearly half of all appointments (41–50% in every
  region). GPs carry most of it (68%) and most telephone work (72%). Other
  practice staff carry most long-lead, face-to-face work.
- **Short appointments:** about half last ten minutes or less. Routine
  consultations are the largest category.
- **Settings:** about 95% of appointments happen in general practice. Primary
  Care Networks and Extended Access Provision are small but growing, and are
  the report's main lever for relieving GP practices.
- **Regions:** the busiest and quietest regions work in the same way, so
  capacity should follow population and demand.
- **Twitter:** healthcare hashtags are mostly positive or neutral, and
  digital-health hashtags lean positive. This supports expanding remote
  options.

Re-checking the work for this repository turned up two things:
- **A chart bug.** Three bars in one chart were empty because of a
  double-space label mismatch ([4](docs/04-staff-mode-and-lead-time.md)).
- **Misread values.** A few values in the written observations were read
  off the wrong chart segment ([6](docs/06-regional-comparison.md),
  [8](docs/08-observations-and-recommendations.md)). The most important
  one: same-day booking is nearly half of appointments, not a fifth.

Both are documented where they occur.

## Running the examples

The examples run on the course data in [`data/`](data/), included with the
permission of LSE and FourthRev. They reproduce the report's figures. From
`examples/`:

```bash
python 01_data_overview.py      # ... through 08_summary_check.py
```

Charts are written to `examples/output/`.
