"""Shared helpers for the Turtle Games examples: load and prepare the course data."""

from pathlib import Path

import pandas as pd

HERE = Path(__file__).resolve().parent
DATA = HERE.parent / "data" / "turtle_reviews.csv"
OUT = HERE / "output"
OUT.mkdir(exist_ok=True)


def load_clean() -> pd.DataFrame:
    """The cleaning used throughout the project: drop language and platform, rename two columns."""
    d = pd.read_csv(DATA)
    d = d.drop(columns=["language", "platform"])
    return d.rename(columns={"remuneration (k£)": "remuneration", "spending_score (1-100)": "spending_score"})


def save(fig, name: str) -> Path:
    path = OUT / f"{name}.png"
    fig.tight_layout()
    fig.savefig(path, dpi=150)
    return path
