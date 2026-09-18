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
