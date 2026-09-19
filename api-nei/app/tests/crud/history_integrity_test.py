"""History identity is a surrogate id, not the event date."""
from datetime import date

import sqlalchemy as sa

from app.core.config import settings
from app.models.history import History
from app.tests.conftest import SessionTesting


def test_two_events_can_share_a_date(db: SessionTesting) -> None:
    db.add_all(
        [
            History(moment=date(2001, 5, 5), title="A", body="a"),
            History(moment=date(2001, 5, 5), title="B", body="b"),
        ]
    )
    db.flush()
    assert db.query(History).filter_by(moment=date(2001, 5, 5)).count() == 2


def test_changing_the_date_keeps_identity(db: SessionTesting) -> None:
    h = History(moment=date(2002, 1, 1), title="C", body="c")
    db.add(h)
    db.flush()
    original = h.id
    h.moment = date(2002, 2, 2)
    db.flush()
    assert h.id == original


def test_id_is_a_database_default(db: SessionTesting) -> None:
    db.execute(
        sa.text(
            f"INSERT INTO {settings.SCHEMA_NAME}.history (moment, title) VALUES ('2003-03-03', 'D')"
        )
    )
    assert db.query(History).filter_by(title="D").one().id is not None
