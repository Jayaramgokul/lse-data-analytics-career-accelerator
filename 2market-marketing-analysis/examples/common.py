"""Shared setup for the 2Market examples: load the CSVs into DuckDB and run SQL.

The original SQL was written for PostgreSQL. DuckDB speaks the same dialect for
everything it uses (GREATEST, EXTRACT, PERCENTILE_CONT ... WITHIN GROUP,
ALTER TABLE ... ADD COLUMN), so the original queries run here unchanged.
"""
import re
from pathlib import Path

import duckdb
import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt
import pandas as pd

HERE = Path(__file__).resolve().parent
ROOT = HERE.parent
DATA = ROOT / "data"
SQL = HERE / "sql"
ORIGINAL_SQL = ROOT / "code" / "original" / "cleaning_up.sql"
OUT = HERE / "output"
OUT.mkdir(exist_ok=True)

# The original age query uses CURRENT_DATE. The analysis was done in 2024, so
# the examples fix the date to the report's date to reproduce its ages.
AS_OF = "DATE '2024-09-09'"

AMOUNTS = ["AmtLiq", "AmtVege", "AmtNonVeg", "AmtPes", "AmtChocolates", "AmtComm"]
PRODUCT_NAMES = {
    "AmtLiq": "Alcoholic beverages", "AmtVege": "Vegetables", "AmtNonVeg": "Meat items",
    "AmtPes": "Fish products", "AmtChocolates": "Chocolates", "AmtComm": "Commodities",
}
CHANNELS = ["Bulkmail_ad", "Twitter_ad", "Instagram_ad", "Facebook_ad", "Brochure_ad"]
PURCHASES = ["NumWebBuy", "NumWalkinPur", "NumDeals"]


def connect():
    """In-memory DuckDB with the two course tables, as they were loaded into PostgreSQL."""
    con = duckdb.connect()
    m = pd.read_csv(DATA / "marketing_data.csv")
    m["Dt_Customer"] = pd.to_datetime(m["Dt_Customer"], format="%m/%d/%y").dt.date
    a = pd.read_csv(DATA / "ad_data.csv", encoding="utf-8-sig")
    con.register("m_df", m)
    con.register("a_df", a)
    con.execute("CREATE TABLE marketing_data AS SELECT * FROM m_df")
    con.execute("CREATE TABLE ad_data AS SELECT * FROM a_df")
    return con


def statements(sql):
    """Split a SQL script into statements, after removing full-line -- comments."""
    code = "\n".join(l for l in sql.splitlines() if not l.strip().startswith("--"))
    return [s.strip() for s in code.split(";") if s.strip()]


def run(con, sql, show=True):
    """Run every statement; return (and optionally print) the result of each SELECT."""
    results = []
    for s in statements(sql):
        rel = con.execute(s)
        if rel.description and rel.description[0][0] not in ("Count", "Success"):
            df = rel.df()
            results.append(df)
            if show:
                print("(no rows)\n" if df.empty else df.to_string(index=False) + "\n")
    return results


def run_file(con, name, show=True):
    return run(con, (SQL / name).read_text(), show)


def prepared():
    """Connection with the joined, checked table "customers" and all derived variables."""
    con = connect()
    run_file(con, "01_checks.sql", show=False)
    run(con, (SQL / "02_derived_variables.sql").read_text().replace("{AS_OF}", AS_OF), show=False)
    return con


def original_section(title):
    """The text of one /* titled */ section of the original SQL file."""
    parts = re.split(r"(?m)^/\*\s*(.*?)\s*\*/\s*$", ORIGINAL_SQL.read_text())
    sections = {parts[i]: parts[i + 1] for i in range(1, len(parts), 2)}
    return sections[title]


def save(fig, name):
    fig.tight_layout()
    fig.savefig(OUT / name, dpi=120)
    plt.close(fig)
    print(f"  saved output/{name}")
