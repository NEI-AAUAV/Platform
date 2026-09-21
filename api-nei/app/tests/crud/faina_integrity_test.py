"""Data-integrity tests for the Faina domain.

No dedicated tests existed for faina/faina_role before this pass (zero
coverage). Focuses on the bug the CMS refactor fixes directly:
faina_role.weight previously had no default, so creating a role from
Directus (which doesn't populate every field, and doesn't go through
this ORM's Python-side default) failed outright.
"""
import sqlalchemy as sa

from app.core.config import settings
from app.models.faina.faina_role import FainaRole
from app.tests.conftest import SessionTesting


def test_faina_role_weight_has_database_level_default(db: SessionTesting) -> None:
    """Insert without a Python-side default at all (raw SQL, as Directus's
    REST API effectively does — it never sees the ORM's `default=0`) to
    prove the DB column itself has `server_default=0` (alembic migration
    c6d8e0f2a4b6), not just an application-level convenience."""
    db.execute(
        sa.text(f"INSERT INTO {settings.SCHEMA_NAME}.faina_role (name) VALUES ('Vogal')")
    )
    db.flush()

    role = db.query(FainaRole).filter_by(name="Vogal").one()
    assert role.weight == 0


def test_faina_role_weight_explicit_value_is_respected(db: SessionTesting) -> None:
    role = FainaRole(name="Coordenador", weight=10)
    db.add(role)
    db.flush()

    assert role.weight == 10


# ---- faina_member identity: a linked user or a non-blank name ------------
import pytest
from datetime import datetime
from sqlalchemy.exc import IntegrityError

from app.models.faina.faina import Faina
from app.models.faina.faina_member import FainaMember
from app.models.user import User


def _faina_and_role(db: SessionTesting):
    faina = Faina(mandate="2025/26")
    role = FainaRole(name="Vogal")
    db.add_all([faina, role])
    db.flush()
    return faina, role


def _user(db: SessionTesting) -> User:
    u = User(name="Eva", surname="Lima", created_at=datetime(2026, 1, 1), updated_at=datetime(2026, 1, 1))
    db.add(u)
    db.flush()
    return u


def test_faina_member_name_only_is_allowed(db: SessionTesting) -> None:
    faina, role = _faina_and_role(db)
    db.add(FainaMember(faina_id=faina.id, role_id=role.id, name="Rui"))
    db.flush()


def test_faina_member_user_only_is_allowed(db: SessionTesting) -> None:
    faina, role = _faina_and_role(db)
    db.add(FainaMember(faina_id=faina.id, role_id=role.id, member_id=_user(db).id))
    db.flush()


def test_faina_member_user_and_name_is_allowed(db: SessionTesting) -> None:
    faina, role = _faina_and_role(db)
    db.add(FainaMember(faina_id=faina.id, role_id=role.id, member_id=_user(db).id, name="Eva L."))
    db.flush()


def test_faina_member_without_user_or_name_is_rejected(db: SessionTesting) -> None:
    faina, role = _faina_and_role(db)
    db.add(FainaMember(faina_id=faina.id, role_id=role.id))
    with pytest.raises(IntegrityError):
        db.flush()


def test_faina_member_blank_name_without_user_is_rejected(db: SessionTesting) -> None:
    faina, role = _faina_and_role(db)
    db.add(FainaMember(faina_id=faina.id, role_id=role.id, name="  "))
    with pytest.raises(IntegrityError):
        db.flush()
