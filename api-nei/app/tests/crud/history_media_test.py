"""history_media invariants, and what the timeline loads of it."""
import uuid
from datetime import date

import pytest
import sqlalchemy as sa
from sqlalchemy import event
from sqlalchemy.exc import IntegrityError

from app.api.api_v1.history import _load_list
from app.core.config import settings
from app.db.base_class import Base
from app.integrations.google_drive import DRIVE_FILE_URL_PATTERN, extract_file_id
from app.models.history import History, HistoryMedia
from app.tests.conftest import SessionTesting

DRIVE_FILE = "https://drive.google.com/file/d/1AbCdEfGhIjK/view"


@pytest.fixture(autouse=True)
def lh3_image_urls(monkeypatch):
    monkeypatch.setattr(settings, "DRIVE_IMAGE_BASE_URL", "https://lh3.googleusercontent.com/d/")


def _milestone(db: SessionTesting, title: str = "Marco", **kwargs) -> History:
    milestone = History(moment=date(2024, 1, 1), title=title, **kwargs)
    db.add(milestone)
    db.flush()
    return milestone


# --- single source: upload XOR Drive link ----------------------------------

def test_upload_only_media_is_accepted(db: SessionTesting) -> None:
    db.add(HistoryMedia(history_id=_milestone(db).id, photo_asset=uuid.uuid4()))
    db.flush()


def test_drive_only_media_is_accepted(db: SessionTesting) -> None:
    db.add(HistoryMedia(history_id=_milestone(db).id, drive_url=DRIVE_FILE))
    db.flush()


@pytest.mark.parametrize(
    "source",
    [{}, {"photo_asset": uuid.uuid4(), "drive_url": DRIVE_FILE}],
    ids=["neither", "both"],
)
def test_media_needs_exactly_one_source(db: SessionTesting, source: dict) -> None:
    db.add(HistoryMedia(history_id=_milestone(db).id, **source))
    with pytest.raises(IntegrityError, match="ck_history_media_single_source"):
        db.flush()
    db.rollback()


def test_model_check_constraints_exist_in_the_migrated_schema(db: SessionTesting) -> None:
    """`alembic check` ignores CHECK constraints: compare names directly, so
    `create_all()` and the migration chain build the same rules."""
    in_db = set(
        db.execute(
            sa.text(
                "SELECT conname FROM pg_constraint "
                "WHERE contype = 'c' AND connamespace = to_regnamespace(:schema)"
            ),
            {"schema": settings.SCHEMA_NAME},
        ).scalars()
    )
    in_models = {
        constraint.name
        for table in Base.metadata.tables.values()
        for constraint in table.constraints
        if isinstance(constraint, sa.CheckConstraint)
    }
    assert in_models <= in_db, in_models - in_db
    assert "ck_history_media_single_source" in in_models


# --- Drive file links: SQL and Python agree ---------------------------------

@pytest.mark.parametrize(
    "url",
    [
        DRIVE_FILE,
        "https://drive.google.com/file/d/1AbCdEfGhIjK",
        "https://docs.google.com/file/d/1AbCdEfGhIjK/edit",
        "https://drive.google.com/u/0/file/d/1AbCdEfGhIjK/view",
        "https://drive.google.com/open?id=1AbCdEfGhIjK",
        "https://drive.google.com/uc?export=download&id=1AbCdEfGhIjK",
        "https://drive.google.com/uc?id=1AbCdEfGhIjK&export=download",
        "http://drive.google.com/open?id=1AbCdEfGhIjK#x",
        "https://drive.google.com/drive/folders/1AbCdEfGhIjK",
        "https://drive.google.com/open?id=short",
        "https://drive.google.com/open?xid=1AbCdEfGhIjK",
        "https://drive.google.com/open?id=1AbCdEfGhIjK!",
        "https://drive.google.com/open?id=1AbCdEfGhIjK\n",
        "https://drive.google.com.evil.com/file/d/1AbCdEfGhIjK",
        "https://user@drive.google.com/file/d/1AbCdEfGhIjK",
        "https://drive.google.com:8443/file/d/1AbCdEfGhIjK",
        "https://drive.google.com/view#/file/d/1AbCdEfGhIjK",
        "https://drive.google.com/view?q=/file/d/1AbCdEfGhIjK",
        "ftp://drive.google.com/file/d/1AbCdEfGhIjK",
        "https://example.com/file/d/1AbCdEfGhIjK/view",
        "not a url",
        "",
    ],
)
def test_sql_and_python_accept_the_same_drive_links(db: SessionTesting, url: str) -> None:
    in_sql = db.execute(
        sa.select(sa.literal(url).regexp_match(DRIVE_FILE_URL_PATTERN))
    ).scalar_one()
    assert in_sql == (extract_file_id(url) is not None)


# --- the timeline loads a summary, not every photo --------------------------

def _statements(db: SessionTesting, fn) -> tuple[object, list[str]]:
    seen: list[str] = []

    def record(conn, cursor, statement, *args):
        seen.append(statement)

    bind = db.get_bind()
    event.listen(bind, "before_cursor_execute", record)
    try:
        result = fn()
    finally:
        event.remove(bind, "before_cursor_execute", record)
    return result, seen


def test_list_loads_one_photo_per_milestone_whatever_the_gallery_size(
    db: SessionTesting,
) -> None:
    photos_per_milestone = 25
    for i in range(4):
        milestone = _milestone(db, f"Galeria {i}")
        db.add_all(
            HistoryMedia(history_id=milestone.id, photo_asset=uuid.uuid4(), weight=w)
            for w in range(photos_per_milestone)
        )
    db.flush()
    db.expunge_all()

    loaded_media: list[HistoryMedia] = []

    def on_load(target, _context):
        loaded_media.append(target)

    event.listen(HistoryMedia, "load", on_load)
    try:
        listed, statements = _statements(db, lambda: _load_list(db))
    finally:
        event.remove(HistoryMedia, "load", on_load)

    assert len(statements) == 2  # milestones + one summary row each
    assert len(loaded_media) == 4  # not 4 * photos_per_milestone
    for i in range(4):
        match = next(m for m in listed if m.title == f"Galeria {i}")
        assert match.gallery_count == photos_per_milestone


def test_list_count_and_cover_skip_unusable_drive_links(db: SessionTesting) -> None:
    milestone = _milestone(db)
    db.add_all(
        [
            HistoryMedia(history_id=milestone.id, drive_url="https://example.com/x", weight=0),
            HistoryMedia(
                history_id=milestone.id,
                drive_url="https://drive.google.com/file/d/2AbCdEfGhIjK/view",
                caption="Primeira válida",
                weight=1,
            ),
            HistoryMedia(history_id=milestone.id, drive_url=DRIVE_FILE, weight=2),
        ]
    )
    db.flush()

    match = next(m for m in _load_list(db) if m.id == milestone.id)
    assert match.gallery_count == 2
    assert match.cover == "https://lh3.googleusercontent.com/d/2AbCdEfGhIjK=w600"
    assert match.cover_alt == "Primeira válida"


def test_list_cover_breaks_weight_ties_by_id(db: SessionTesting) -> None:
    milestone = _milestone(db)
    first = HistoryMedia(history_id=milestone.id, photo_asset=uuid.uuid4(), caption="A", weight=0)
    db.add(first)
    db.flush()
    db.add(HistoryMedia(history_id=milestone.id, photo_asset=uuid.uuid4(), caption="B", weight=0))
    db.flush()

    match = next(m for m in _load_list(db) if m.id == milestone.id)
    assert match.cover_alt == "A"


def test_list_ignores_media_of_unpublished_milestones(db: SessionTesting) -> None:
    hidden = _milestone(db, published=False)
    db.add(HistoryMedia(history_id=hidden.id, photo_asset=uuid.uuid4()))
    db.flush()

    assert all(m.id != hidden.id for m in _load_list(db))
