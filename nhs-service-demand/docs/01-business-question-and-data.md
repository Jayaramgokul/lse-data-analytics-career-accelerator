# 1. The business question and the data

*Report sections 0–1. Notebook section A. Example: [`01_data_overview.py`](../examples/01_data_overview.py).*

## The question

The NHS wanted to know whether general practice has enough capacity for growing
demand, and whether its existing resources are being used well. Two questions
drove the analysis:

- **Capacity:** how many appointments are delivered, by whom, how and when?
- **Utilisation:** where are appointments missed, and which services are
  under-used?

Social media was added as outside context: what people discuss about
healthcare, and how they feel about it.

## The four datasets

| Short name | File | Grain | Period | Appointments |
|---|---|---|---|---|
| `ar` | appointments_regional | Month × ICB | Jan 2020 – Jun 2022 (30 months) | 742.8M |
| `ad` | actual_duration | Day × sub-ICB location | Dec 2021 – Jun 2022 (7 months) | 168.0M |
| `nc` | national_categories | Day × sub-ICB location | Aug 2021 – Jun 2022 (11 months) | 296.0M |
| `tweets` | tweets | One row per tweet | One day | 1,174 tweets |

An ICB is an Integrated Care Board: one of 42 areas that plan health services
for their population.

Each appointment file answers a different part of the question:

- **ar**: appointment status (attended or not), professional type (GP or
  other practice staff), mode (face-to-face, telephone, home visit,
  video/online) and booking lead time.
- **ad**: how long the appointment actually lasted.
- **nc**: what kind of appointment it was (national category, for example
  routine consultation or clinical triage) and where it happened (service
  setting, for example general practice or a Primary Care Network).

## What the first inspection found

- **No missing values** in any file.
- **The periods differ**, so the totals cannot be added or compared directly.
  Each question is answered from the file that covers it.
- **Missing information is hidden in labels.** "Unknown", "Unknown / Data
  Quality", "Unmapped" and "Inconsistent Mapping" stand in for missing
  values. They are under 5% in most fields, but **24% of appointments
  have no usable duration**, and 13% of national categories are unmapped or
  inconsistent.

The metadata adds a caution: GP systems were built for running practices, not
for analysis. There are no national data-entry standards, so data quality
varies between practices.

The report then grouped the fields two ways, which organises the rest of the
analysis:
- appointment information (status, professional, mode, lead time, duration,
  category, setting);
- geographical information (ICB and sub-ICB codes).
