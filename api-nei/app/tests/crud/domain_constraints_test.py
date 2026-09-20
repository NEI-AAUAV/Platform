"""Constraints that must hold even when rows are written by Directus (raw SQL)."""
import pytest
import sqlalchemy as sa
from sqlalchemy.exc import IntegrityError

from app.core.config import settings
from app.tests.conftest import SessionTesting

S = settings.SCHEMA_NAME


def _rgm_mandate(db: SessionTesting, label: str = "2090/91") -> int:
    return db.execute(
        sa.text(f"INSERT INTO {S}.rgm_mandate (label) VALUES (:l) RETURNING id"), {"l": label}
    ).scalar_one()


def _insert_rgm(db: SessionTesting, mandate_id, category: str = "ATA") -> None:
    db.execute(
        sa.text(
            f"INSERT INTO {S}.rgm (category, date, title, mandate_id)"
            " VALUES (:c, now(), 't', :m)"
        ),
        {"c": category, "m": mandate_id},
    )


def test_rgm_accepts_known_categories(db: SessionTesting) -> None:
    mid = _rgm_mandate(db)
    for category in ("ATA", "PAO", "RAC"):
        _insert_rgm(db, mid, category)


@pytest.mark.parametrize("bad", ["XYZ", "ata", ""])
def test_rgm_rejects_unknown_category(db: SessionTesting, bad: str) -> None:
    mid = _rgm_mandate(db)
    with pytest.raises(IntegrityError):
        _insert_rgm(db, mid, bad)


def test_rgm_requires_mandate(db: SessionTesting) -> None:
    with pytest.raises(IntegrityError):
        _insert_rgm(db, None)


def test_rgm_mandate_in_use_cannot_be_deleted(db: SessionTesting) -> None:
    mid = _rgm_mandate(db)
    _insert_rgm(db, mid)
    stmt = sa.text(f"DELETE FROM {S}.rgm_mandate WHERE id = :m")
    with pytest.raises(IntegrityError):
        db.execute(stmt, {"m": mid})


def test_rgm_mandate_label_format(db: SessionTesting) -> None:
    with pytest.raises(IntegrityError):
        _rgm_mandate(db, "abc")


@pytest.mark.parametrize(
    "column,value", [("price", -1), ("number_of_items", -5)]
)
def test_merch_rejects_negative_values(db: SessionTesting, column: str, value: int) -> None:
    stmt = sa.text(f"INSERT INTO {S}.merch (name, {column}) VALUES ('Caneca', :v)")
    with pytest.raises(IntegrityError):
        db.execute(stmt, {"v": value})


def test_merch_accepts_zero_and_positive(db: SessionTesting) -> None:
    db.execute(
        sa.text(f"INSERT INTO {S}.merch (name, price, number_of_items) VALUES ('Caneca', 0, 3)")
    )


def test_faina_mandate_format(db: SessionTesting) -> None:
    stmt = sa.text(f"INSERT INTO {S}.faina (mandate) VALUES ('nope')")
    with pytest.raises(IntegrityError):
        db.execute(stmt)
