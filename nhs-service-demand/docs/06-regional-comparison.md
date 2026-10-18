# 6. The busiest and quietest regions

*Report Figs 4.16–4.25 and appendix Figs 5.4–5.6. Notebook section D. Example: [`06_regional_comparison.py`](../examples/06_regional_comparison.py).*

## Approach

The 42 ICBs were ranked by total appointments. The **top five** and **bottom
five** were then compared on every variable from sections 3–5. The question:
do busy regions work differently, or are they just bigger?

| | ICBs (appointments, Jan 2020 – Jun 2022) |
|---|---|
| Top 5 | E54000050 (43.1M), E54000054 (36.1M), E54000057 (34.1M), E54000008 (33.1M), E54000027 (29.4M) |
| Bottom 5 | E54000036 (9.6M), E54000043 (9.2M), E54000034 (9.1M), E54000038 (7.8M), E54000011 (6.5M) |

The busiest ICB has 6.6 times the appointments of the quietest. All three
datasets give the same top and bottom five, so the comparison is consistent
across files.

## What differs and what doesn't

| Measure | Top 5 | Bottom 5 |
|---|---|---|
| Attended | 94.0–96.6% | 95.3–96.6% |
| GP share | 44.7–57.6% | 48.6–59.7% |
| Face-to-face | 57.1–65.7% | 53.9–68.3% |
| Telephone | 33.2–41.2% | 31.0–45.4% |
| Same-day bookings | 44.4–48.7% | 41.3–49.6% |
| 1–10 minute appointments | 46.9–52.3% | 46.5–49.9% |
| In general practice | 92.3–96.6% | 94.0–96.8% |

**The ranges overlap on every measure.** The busiest regions are not run
differently from the quietest; they serve more people. The individual
differences are of degree:

- **E54000057:** highest missed-appointment rate (6.0%).
- **E54000034:** leans most on GPs (59.7%) and on the telephone (45.4%).
- **E54000027:** most video/online (2.1%) and most Extended Access (2.0%).
- **E54000054:** most Primary Care Network use (3.8%).

By national category (Fig 4.24), the top five together deliver about **four
times** the routine, acute and triage appointments of the bottom five
(3.8–4.5 times). That matches their four-times larger total volume: the
difference is size again, not mix.

## Reading the stacked charts: corrections

The charts in Figs 4.17–4.25 are correct. Some of the written observations
in the appendix (Figs 5.4–5.5) took values from the wrong segment or region.

| Report says | Data and chart show |
|---|---|
| Top 5: same-day bookings 20.5–21.8%; up to 48.7% booked 15–21 days ahead | Same-day is 44.4–48.7%; 20.5–21.8% is part of the 2–7 day range |
| Bottom 5: same-day as low as 8.4%; up to 49.4% booked 15–21 days ahead | Same-day is 41.3–49.6%; 8.4% is E54000036's 1-day share |
| Top 5: GPs handle 43.8–56.2% | GP share is 44.7–57.6%; 43.8% and 56.2% are E54000008's two shares |
| E54000034 relies on other staff (59.7%) | E54000034 has the highest GP share (59.7%) |
| Telephone 41.2% in E54000057, 39.6% in E54000008 | The other way round |
| Top 5: 16–20 minute appointments only 6–7% | That is the 31–60 minute share (6.3–7.7%); 16–20 minutes is 11.4–12.9% |

Most of these do not change a conclusion. **The same-day one does.** The
report concluded that bottom regions are dominated by long lead times. In
fact **same-day booking is the largest category in every region**, at
41–50%. That makes the case for urgent, same-day capacity stronger, not
weaker.

## What it led to

- **Plan capacity by population and demand.** Practice styles barely differ
  between regions.
- **Share practice between regions.**
  - Higher-DNA regions (E54000057) can adopt the reminder practices of
    lower-DNA ones (E54000054, E54000043, both 3.4%).
  - Regions using few remote appointments can learn from those using many.
