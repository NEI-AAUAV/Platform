"""Paged listings must not issue one query per row for serialized relations."""
from datetime import datetime

from sqlalchemy import event

from app import crud
from app.models import News, User
from app.schemas.news import NewsInDB
from app.tests.conftest import SessionTesting

ROWS = 8
# one COUNT + one page query; anything above means per-row lazy loads.
MAX_STATEMENTS = 3


def _seed_news_with_distinct_authors(db: SessionTesting) -> None:
    for i in range(ROWS):
        db.add(
            User(
                id=100 + i,
                name=f"Author{i}",
                surname="X",
                scopes=[],
                created_at=datetime(2022, 8, 4),
                updated_at=datetime(2022, 8, 5),
            )
        )
    db.flush()
    for i in range(ROWS):
        db.add(
            News(
                author_id=100 + i,
                category="EVENT",
                title=f"n{i}",
                public=True,
                created_at=datetime(2024, 1, 1, 0, i),
                updated_at=datetime(2024, 1, 1, 0, i),
            )
        )
    db.flush()
    db.expunge_all()  # force relationships to be loaded from the DB again


def _count_statements(db: SessionTesting, fn) -> int:
    statements: list[str] = []

    def record(conn, cursor, statement, *args):
        statements.append(statement)

    bind = db.get_bind()
    event.listen(bind, "before_cursor_execute", record)
    try:
        fn()
    finally:
        event.remove(bind, "before_cursor_execute", record)
    return len(statements)


def test_news_listing_does_not_query_per_author(db: SessionTesting) -> None:
    _seed_news_with_distinct_authors(db)

    def list_and_serialize() -> None:
        _, items = crud.news.get_news_by_categories(db, [], page=1, size=20)
        assert len(items) == ROWS
        for item in items:
            NewsInDB.model_validate(item)

    assert _count_statements(db, list_and_serialize) <= MAX_STATEMENTS


def test_rgm_listing_does_not_query_per_mandate(db: SessionTesting) -> None:
    """RgmInDB.mandate reads mandate_ref, so the join must be eager-loaded."""
    from app.models.rgm import Rgm
    from app.models.rgm_mandate import RgmMandate
    from app.schemas.rgm import RgmInDB

    for i in range(ROWS):
        db.add(RgmMandate(id=200 + i, label=f"20{10 + i}/{11 + i}"))
    db.flush()
    for i in range(ROWS):
        db.add(
            Rgm(
                category="ATA",
                mandate_id=200 + i,
                date=datetime(2024, 1, 1, 0, i),
                title=f"doc{i}",
            )
        )
    db.flush()
    db.expunge_all()

    def list_and_serialize() -> None:
        items = crud.rgm.get_by(db)
        assert len(items) == ROWS
        for item in items:
            RgmInDB.model_validate(item)

    assert _count_statements(db, list_and_serialize) <= 2
