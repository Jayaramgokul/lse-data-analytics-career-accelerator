# 5. Appointment length, type and setting

*Report Figs 4.10–4.15. Notebook section C, 2–3. Example: [`05_duration_and_categories.py`](../examples/05_duration_and_categories.py).*

## How long appointments last (Fig 4.10)

These figures cover the 76% of appointments with a recorded duration,
December 2021 – June 2022.

| Duration | Share |
|---|---|
| 1–5 minutes | 22.4% |
| **6–10 minutes** | **26.5%** |
| 11–15 minutes | 19.7% |
| 16–20 minutes | 12.5% |
| 21–30 minutes | 11.8% |
| 31–60 minutes | 7.1% |

**Nearly half (48.9%) last ten minutes or less.** Every month has the same
shape. **March 2022** was the busiest month in every duration band.

## What kind of appointment (Figs 4.11–4.14)

There are 16 national categories. Five of them account for 96% of mapped
appointments:

| Category | Appointments |
|---|---|
| General consultation, routine | 97.3M |
| General consultation, acute | 53.7M |
| Clinical triage | 41.5M |
| Planned clinics | 28.0M |
| Planned clinical procedure | 25.7M |

The analysis kept these five. In the submitted notebook this filter
(`nc_filtered`) came from a working notebook run in the same session; the
example defines it explicitly.

**Within each service setting:**

| Setting | Appointments | Routine | Acute | Triage | Planned clinics | Planned procedures |
|---|---|---|---|---|---|---|
| General Practice | 237.0M | **39.4%** | 22.0% | 17.0% | 11.1% | 10.5% |
| Primary Care Network | 4.2M | **50.9%** | 14.6% | 8.2% | 20.6% | 5.7% |
| Other | 3.4M | 40.8% | 17.9% | 17.0% | 15.3% | 9.0% |
| Extended Access Provision | 1.6M | 24.5% | 25.3% | 23.5% | 16.0% | 10.6% |

- **Routine consultations** are the largest category everywhere except
  Extended Access Provision, where routine, acute and triage are almost even.
- **Over time**, the mix barely moves. Routine stays at 37–41% of the five
  categories each month. Planned procedures briefly rose to 15.4% in
  October 2021, probably the autumn vaccination season.

## Where (Fig 4.15)

| Setting | Share of mapped appointments | Monthly range |
|---|---|---|
| General Practice | **95.0%** | 94.5–95.4% |
| Primary Care Network | 2.3% | **1.9% → 2.8%** |
| Other | 1.9% | 1.8–2.0% |
| Extended Access Provision | 0.8% | 0.7–0.8% |

General practice does almost all the work. **Primary Care Networks** (groups of
practices sharing staff) are small but grew steadily over the eleven months.
**Extended Access Provision** (evening and weekend appointments) handled
161,000–232,000 appointments a month.

## What it led to

- **Use Primary Care Networks and Extended Access more.** Move routine and
  planned work there to relieve GP practices. They already exist and are
  growing, but carry only about 3% of appointments.
- **Plan for short appointments.** Some brief interactions could be automated
  or handled online.
- **Staff for the peaks.** March is the busiest month.
