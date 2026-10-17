# Data

Course data for the LSE DA101 assignment, included with the permission of LSE
and FourthRev. [`metadata_2Market.txt`](metadata_2Market.txt) describes every
field. The customer table is adapted by the course from the public Kaggle
dataset *Marketing Analytics* (Jack Daoud, CC0), with renamed columns.

| File | Rows | Contents |
|---|---|---|
| `marketing_data.csv` | 2,216 | One row per customer: demographics, spending by product group, purchases by channel, website visits, campaign response, complaints, country, total lead conversions |
| `ad_data.csv` | 2,216 | One row per customer: conversion (0/1) through each of five advertising channels, and their total |

`ad_data.csv` begins with a byte-order mark. The examples read it with
`encoding="utf-8-sig"`.
