# 4. Who sees patients, how, and how far ahead

*Report Figs 4.5–4.9. Notebook section C, 1.2–1.3. Example: [`04_staff_mode_lead_time.py`](../examples/04_staff_mode_lead_time.py).*

## GPs and other practice staff do different work (Figs 4.5–4.6)

GPs deliver 51% of appointments and other practice staff (nurses, healthcare
assistants and others) 46%. The mix differs sharply by type of appointment:

| | GP share |
|---|---|
| Telephone | **71.8%** |
| Video/Online | 51.8% |
| Home Visit | 46.4% |
| Face-to-Face | **41.6%** |
| Same-day appointments | **67.8%** |
| Booked 2–7 days ahead | 43.1% |
| Booked more than 28 days ahead | **23.7%** |

**GPs handle urgent, remote demand.** Other practice staff handle planned,
in-person work booked well ahead. This also explains part of the gap in missed
appointments in [3](03-attendance-and-missed-appointments.md): other staff
carry more of the long-lead bookings that patients tend to miss.

## Lead time and mode (Fig 4.8)

| Booked | Face-to-face | Telephone |
|---|---|---|
| Same day | 48.8% | 49.9% |
| 1 day | 61.0% | 37.2% |
| 2–7 days | 69.6% | 29.2% |
| 8–14 days | 76.1% | 23.0% |
| 15–21 days | 77.8% | 21.3% |
| 22–28 days | 80.3% | 18.7% |
| More than 28 days | 86.8% | 12.2% |

Same-day demand splits evenly between telephone and face-to-face. The further
ahead the booking, the more likely the appointment is face to face.

> **Correction.** In the report, Fig 4.8 shows
> only four of the seven lead-time bars. The 8–14, 15–21 and 22–28 day bars
> are empty. The notebook put the bars in time order using labels typed
> with single spaces ("8 to 14 Days"). The data's labels have double spaces
> ("8  to 14 Days"), so `reindex()` found no match and left those three
> categories empty. The example orders by the data's own labels and shows all
> seven. The conclusion is unchanged: the face-to-face share rises steadily
> with lead time.

## Over time (Figs 4.7, 4.9)

- **Professional type:** the GP share moved only between 48.2% and 56.7% a
  month.
- **Mode:** the pandemic shows clearly.

| Month | Face-to-face | Telephone |
|---|---|---|
| January 2020 | 83.9% | 14.3% |
| April 2020 | 49.0% | 50.1% |
| June 2022 | 66.6% | 32.1% |

- **Home visits and video** stayed below 1% throughout.

Telephone appointments rose to half of all appointments during the first
lockdown. Face-to-face had recovered to two-thirds by mid-2022, but not to its
pre-pandemic level.

## What it led to

- **Optimise GP and staff use:** give GPs more of the future, non-urgent
  bookings and other staff more of the same-day work, where appropriate.
- **Expand remote options:** telephone appointments are rarely missed and
  already carry much of the same-day demand.
