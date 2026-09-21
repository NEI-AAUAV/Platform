"""The chain must survive schema states production actually has.

Production ran no migrations for years, so columns and constraints were
created out of band. Each test here reproduces one such state, seeded at the
revision production is stamped at, and asserts `upgrade head` still completes.
"""
import pytest
import sqlalchemy as sa
from alembic import command
from alembic.config import Config

from app.core.config import settings
from app.tests.conftest import ALEMBIC_INI

# The revision production is stamped at; drift is anything applied on top of it.
BASELINE = "b2c3d4e5f6a7"
SCRATCH_DB = "nei_drift_test"


def _config(url: str) -> Config:
    cfg = Config(str(ALEMBIC_INI))
    cfg.set_main_option("sqlalchemy.url", url)
    return cfg


@pytest.fixture
def drift_url() -> str:
    """A scratch database at BASELINE, thrown away afterwards."""
    base = sa.engine.make_url(settings.TEST_POSTGRES_URI)
    admin = sa.create_engine(
        base.set(database="postgres"), isolation_level="AUTOCOMMIT"
    )
    with admin.connect() as conn:
        conn.execute(sa.text(f'DROP DATABASE IF EXISTS "{SCRATCH_DB}"'))
        conn.execute(sa.text(f'CREATE DATABASE "{SCRATCH_DB}"'))

    url = base.set(database=SCRATCH_DB).render_as_string(hide_password=False)
    command.upgrade(_config(url), BASELINE)
    yield url

    sa.create_engine(url).dispose()
    with admin.connect() as conn:
        conn.execute(sa.text(f'DROP DATABASE IF EXISTS "{SCRATCH_DB}" WITH (FORCE)'))
    admin.dispose()


def _execute(url: str, statements: str) -> None:
    engine = sa.create_engine(url, isolation_level="AUTOCOMMIT")
    with engine.connect() as conn:
        conn.execute(sa.text(statements))
    engine.dispose()


def _head(url: str) -> str:
    engine = sa.create_engine(url)
    with engine.connect() as conn:
        version = conn.execute(
            sa.text(f"SELECT version_num FROM {settings.SCHEMA_NAME}.alembic_version")
        ).scalar_one()
    engine.dispose()
    return version


def test_survives_asset_column_created_out_of_band(drift_url: str) -> None:
    """Infrastructure provisioning added the *_asset columns on some deployments."""
    _execute(
        drift_url,
        f"ALTER TABLE {settings.SCHEMA_NAME}.faina ADD COLUMN image_asset uuid",
    )

    command.upgrade(_config(drift_url), "head")

    assert _head(drift_url) != BASELINE


def test_survives_foreign_key_into_the_directus_schema(drift_url: str) -> None:
    """Older Directus provisioning created real cross-schema foreign keys.

    d0c2e4f6a8b1 runs first and must not reject what a8c0e2f4b6d7 later drops.
    """
    schema = settings.SCHEMA_NAME
    _execute(
        drift_url,
        f"""
        CREATE SCHEMA directus;
        CREATE TABLE directus.directus_files (id uuid PRIMARY KEY);
        ALTER TABLE {schema}.team_member ADD COLUMN header_asset uuid;
        ALTER TABLE {schema}.team_member
            ADD CONSTRAINT team_member_header_asset_foreign
            FOREIGN KEY (header_asset) REFERENCES directus.directus_files(id);
        """,
    )

    command.upgrade(_config(drift_url), "head")

    engine = sa.create_engine(drift_url)
    with engine.connect() as conn:
        remaining = conn.execute(
            sa.text(
                "SELECT count(*) FROM pg_constraint"
                " WHERE conname = 'team_member_header_asset_foreign'"
            )
        ).scalar_one()
    engine.dispose()
    assert remaining == 0


def test_history_surrogate_id_survives_duplicate_moments(drift_url: str) -> None:
    """A hand-dropped history PK allows duplicate dates; ids must still be unique."""
    schema = settings.SCHEMA_NAME
    _execute(
        drift_url,
        f"""
        ALTER TABLE {schema}.history DROP CONSTRAINT pk_history;
        INSERT INTO {schema}.history (moment, title)
        VALUES ('2024-01-01', 'a'), ('2024-01-01', 'b');
        """,
    )

    command.upgrade(_config(drift_url), "head")

    engine = sa.create_engine(drift_url)
    with engine.connect() as conn:
        rows = conn.execute(
            sa.text(f"SELECT id FROM {schema}.history ORDER BY id")
        ).scalars().all()
    engine.dispose()
    assert len(rows) == len(set(rows)) == 2


# The mandates production actually holds: the convention switched to AAAA/AA
# after 2022, so both styles coexist and neither can be rewritten (2022 -> 2022/23
# would collide with the real 2022/23 row).
PRODUCTION_MANDATES = [
    "2013", "2014", "2015", "2016", "2017", "2018", "2019",
    "2020", "2021", "2022", "2022/23", "2023/24", "2024/25", "2025/26",
]


def test_team_mandate_accepts_the_formats_production_holds(drift_url: str) -> None:
    schema = settings.SCHEMA_NAME
    values = ", ".join(f"('{m}', 1, 1)" for m in PRODUCTION_MANDATES)
    _execute(
        drift_url,
        f"""
        INSERT INTO {schema}.team_role (id, name, weight) VALUES (1, 'Vogal', 0);
        INSERT INTO {schema}."user" (id, name, surname, scopes, updated_at, created_at)
        VALUES (1, 'Dev', 'Tester', ARRAY[]::text[], now(), now());
        INSERT INTO {schema}.team_member (mandate, role_id, user_id) VALUES {values};
        """,
    )

    command.upgrade(_config(drift_url), "head")

    engine = sa.create_engine(drift_url)
    with engine.connect() as conn:
        migrated = conn.execute(
            sa.text(f"SELECT mandate FROM {schema}.team_mandate ORDER BY 1")
        ).scalars().all()
    engine.dispose()
    assert migrated == sorted(PRODUCTION_MANDATES)
