"""Migration-chain guards: one head, no model drift, no Directus infra in Alembic."""
import re
from pathlib import Path

from alembic import command
from alembic.script import ScriptDirectory

from app.tests.conftest import _alembic_config

VERSIONS = Path(__file__).resolve().parents[2] / "alembic" / "versions"

# Revisions that used to provision Directus and are now intentional no-ops.
RETIRED = {
    "d3c7f0a1b2e4",
    "f2b4d8e1a9c3",
    "e8f0a2b4c6d8",
    "f9a1b3c5d7e9",
    "b5c7d9e1f3a5",
}


def test_single_alembic_head() -> None:
    heads = ScriptDirectory.from_config(_alembic_config()).get_heads()
    assert len(heads) == 1, heads


def test_models_match_migrated_schema(connection) -> None:
    """`alembic check`: fails if a model differs from what the chain builds."""
    command.check(_alembic_config())


def test_alembic_does_not_own_directus_infrastructure() -> None:
    """Role/schema/grants for Directus belong to the Infrastructure repository."""
    forbidden = re.compile(r"CREATE ROLE|ALTER ROLE|GRANT\s|REVOKE\s|directus_svc", re.I)
    offenders = []
    for path in VERSIONS.glob("*.py"):
        rev = path.name.split("_")[0]
        text = path.read_text()
        if rev in RETIRED:
            # Retired revisions may only *mention* the role in their docstring.
            body = text.split('"""', 2)[-1]
            if forbidden.search(body):
                offenders.append(path.name)
        elif forbidden.search(re.sub(r'""".*?"""', "", text, flags=re.S)):
            offenders.append(path.name)
    assert not offenders, offenders


# Constraints the models name explicitly; everything else must follow the
# convention in app/db/base_class.py. Keep in step with the same list in
# alembic/versions/d0c2e4f6a8b1_normalise_constraint_names.py.
EXPLICITLY_NAMED = {
    ("news", "fk_author_id"),
    ("note", "fk_author_id"),
    ("note", "fk_note_author_id"),
    ("note", "fk_subject_id"),
    ("note", "fk_teacher_id"),
    ("senior", "uc_year_course"),
    ("video__video_tags", "uq_video__video_tags_video_tag"),
}


def test_constraint_names_follow_the_convention(db) -> None:
    """Migrations drop constraints by their convention name, so the schema has
    to use it. `alembic check` does not catch foreign-key or primary-key name
    drift, which is how team_member_role_id_fkey went unnoticed until it broke
    a deploy."""
    import sqlalchemy as sa

    from app.core.config import settings

    rows = db.execute(
        sa.text(
            """
            SELECT t.relname AS table_name, c.conname, c.contype,
                   (SELECT array_agg(a.attname ORDER BY k.ord)
                      FROM unnest(c.conkey) WITH ORDINALITY AS k(attnum, ord)
                      JOIN pg_attribute a
                        ON a.attrelid = c.conrelid AND a.attnum = k.attnum) AS cols,
                   rt.relname AS ref_table
            FROM pg_constraint c
            JOIN pg_class t       ON t.oid = c.conrelid
            LEFT JOIN pg_class rt ON rt.oid = c.confrelid
            WHERE c.connamespace = to_regnamespace(:schema)
              AND c.contype IN ('p', 'u', 'f')
              AND t.relname <> 'alembic_version'
            """
        ),
        {"schema": settings.SCHEMA_NAME},
    ).fetchall()

    assert rows, "no constraints found; is the schema migrated?"

    offenders = []
    for row in rows:
        if (row.table_name, row.conname) in EXPLICITLY_NAMED:
            continue
        joined = "_".join(row.cols or [])
        if row.contype == "p":
            want = f"pk_{row.table_name}"
        elif row.contype == "u":
            want = f"uq_{row.table_name}_{joined}"
        else:
            want = f"fk_{row.table_name}_{joined}_{row.ref_table}"
        if row.conname != want:
            offenders.append(f"{row.table_name}.{row.conname} (expected {want})")

    assert not offenders, offenders
