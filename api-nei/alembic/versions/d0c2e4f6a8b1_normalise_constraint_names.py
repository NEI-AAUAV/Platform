"""rename legacy constraints to the project's naming convention

Revision ID: d0c2e4f6a8b1
Revises: b2c3d4e5f6a7
Create Date: 2026-09-20

`app/db/base_class.py` declares a `naming_convention`, so everything Alembic
and SQLAlchemy *create* is named `pk_<table>`, `fk_<table>_<cols>_<reftable>`,
`uq_<table>_<cols>`. Tables created before that convention still carry
PostgreSQL's auto-generated names (`team_member_role_id_fkey`,
`video__video_tags_pkey`, ...), so a later migration that drops a pre-existing
constraint by its convention name fails on such a database. Two in this chain
do, and both were reproduced against a replica of production:

* c3d4e5f6a7b8 drops "fk_team_member_role_id_team_role" -> aborts outright.
* a7c2e4f6b8d1 drops "pk_video__video_tags" IF EXISTS -> silently no-ops, then
  adds a second primary key and fails with "multiple primary keys ... are not
  allowed".

Renaming is also what makes `CRUDBase._integrity_error_handler` work: it looks
a violated constraint up by name in each crud module's `_foreign_key_checks`,
and those dicts are keyed by convention names. On a legacy-named database most
of those lookups miss, so the API answers 500 where it means to answer 400.

Only names PostgreSQL generated itself are adopted. The constraints the models
name explicitly keep the name the code refers to them by; `_EXPLICIT` below is
that list, taken from `Base.metadata`.

Renaming a constraint is a catalogue update -- no table rewrite, no data read
-- but it takes ACCESS EXCLUSIVE on each table, and `env.py` runs the whole
upgrade in one transaction, so those locks are held until the last revision
commits. `lock_timeout` keeps a stalled rename from convoying every reader
behind it; the transaction rolls back cleanly.

The downgrade is intentionally a no-op. The previous names were whatever
PostgreSQL happened to generate, nothing depends on them, and reconstructing
them adds risk for no benefit.
"""
import hashlib
import logging

import sqlalchemy as sa
from alembic import op

revision = "d0c2e4f6a8b1"
down_revision = "b2c3d4e5f6a7"
branch_labels = None
depends_on = None

SCHEMA = "nei"

log = logging.getLogger("alembic.runtime.migration")

# Constraints the models name explicitly, as (table, name). Derived from
# Base.metadata; the code refers to them by these names, so they are left
# alone. Two of them are created later in this chain, hence absent here.
_EXPLICIT = frozenset(
    {
        ("news", "fk_author_id"),
        ("note", "fk_author_id"),
        ("note", "fk_note_author_id"),
        ("note", "fk_subject_id"),
        ("note", "fk_teacher_id"),
        ("senior", "uc_year_course"),
        ("video__video_tags", "uq_video__video_tags_video_tag"),
    }
)

_CONSTRAINTS = """
SELECT c.conname,
       t.relname  AS table_name,
       c.contype,
       (SELECT array_agg(a.attname ORDER BY k.ord)
          FROM unnest(c.conkey) WITH ORDINALITY AS k(attnum, ord)
          JOIN pg_attribute a
            ON a.attrelid = c.conrelid AND a.attnum = k.attnum) AS cols,
       rt.relname AS ref_table,
       rn.nspname AS ref_schema
FROM pg_constraint c
JOIN pg_class t          ON t.oid = c.conrelid
LEFT JOIN pg_class rt    ON rt.oid = c.confrelid
LEFT JOIN pg_namespace rn ON rn.oid = rt.relnamespace
WHERE c.connamespace = to_regnamespace(:schema)
  AND t.relname <> 'alembic_version'
ORDER BY t.relname, c.conname
"""

_RELATIONS = """
SELECT relname FROM pg_class
WHERE relnamespace = to_regnamespace(:schema) AND relkind IN ('i', 'r', 'v', 'm')
"""


def _truncate(name: str) -> str:
    """SQLAlchemy's rule for names past the identifier limit."""
    if len(name) <= 63:
        return name
    return name[:55] + "_" + hashlib.md5(name.encode()).hexdigest()[-4:]


def _expected(contype: str, table: str, cols, ref_table) -> str:
    """The name the convention in app/db/base_class.py produces."""
    joined = "_".join(cols or [])
    if contype == "p":
        return _truncate(f"pk_{table}")
    if contype == "u":
        return _truncate(f"uq_{table}_{joined}")
    return _truncate(f"fk_{table}_{joined}_{ref_table}")


def _postgres_default(contype: str, table: str, cols) -> str:
    """The name PostgreSQL generates when none is supplied."""
    joined = "_".join(cols or [])
    if contype == "p":
        return f"{table}_pkey"
    if contype == "u":
        return f"{table}_{joined}_key"
    return f"{table}_{joined}_fkey"


def upgrade() -> None:
    conn = op.get_bind()
    quote = conn.dialect.identifier_preparer.quote

    op.execute("SET LOCAL lock_timeout = '5s'")

    rows = conn.execute(sa.text(_CONSTRAINTS), {"schema": SCHEMA}).fetchall()
    # Constraint names are unique per table across every constraint type, and
    # a PK/UNIQUE rename also renames its backing index, which shares the
    # schema-wide relation namespace.
    per_table = {(r.table_name, r.conname) for r in rows}
    relations = {
        r.relname
        for r in conn.execute(sa.text(_RELATIONS), {"schema": SCHEMA}).fetchall()
    }

    renamed = 0
    for row in rows:
        if row.contype not in ("p", "u", "f"):
            continue
        # A foreign key into another schema (Directus) cannot match a convention
        # built from nei table names; a8c0e2f4b6d7 drops these later.
        if row.contype == "f" and row.ref_schema not in (None, SCHEMA):
            log.info(
                "skipping %s.%s: references schema %s",
                row.table_name,
                row.conname,
                row.ref_schema,
            )
            continue
        want = _expected(row.contype, row.table_name, row.cols, row.ref_table)
        if want == row.conname:
            continue
        if (row.table_name, row.conname) in _EXPLICIT:
            log.info("skipping %s.%s: named explicitly", row.table_name, row.conname)
            continue
        if row.conname != _postgres_default(row.contype, row.table_name, row.cols):
            log.info(
                "skipping %s.%s: not a PostgreSQL-generated name",
                row.table_name,
                row.conname,
            )
            continue
        if (row.table_name, want) in per_table:
            raise RuntimeError(
                f"Cannot rename {SCHEMA}.{row.table_name}.{row.conname} to {want!r}: "
                f"{row.table_name} already has a constraint with that name."
            )
        if row.contype in ("p", "u") and want in relations:
            raise RuntimeError(
                f"Cannot rename {SCHEMA}.{row.table_name}.{row.conname} to {want!r}: "
                f"a relation called {want!r} already exists in {SCHEMA} and the "
                "backing index would collide with it."
            )
        op.execute(
            f"ALTER TABLE {quote(SCHEMA)}.{quote(row.table_name)} "
            f"RENAME CONSTRAINT {quote(row.conname)} TO {quote(want)}"
        )
        log.info("renamed %s.%s -> %s", row.table_name, row.conname, want)
        per_table.discard((row.table_name, row.conname))
        per_table.add((row.table_name, want))
        if row.contype in ("p", "u"):
            relations.discard(row.conname)
            relations.add(want)
        renamed += 1

    # Anything still off-convention that is not a declared exception means a
    # name this migration did not recognise -- a PostgreSQL-truncated or
    # de-duplicated default, or one someone set by hand. Fail here, named,
    # rather than thirteen revisions later with "constraint does not exist".
    leftovers = [
        (r.table_name, r.conname)
        for r in conn.execute(sa.text(_CONSTRAINTS), {"schema": SCHEMA}).fetchall()
        if r.contype in ("p", "u", "f")
        and r.conname != _expected(r.contype, r.table_name, r.cols, r.ref_table)
        and (r.table_name, r.conname) not in _EXPLICIT
        and not (r.contype == "f" and r.ref_schema not in (None, SCHEMA))
    ]
    if leftovers:
        raise RuntimeError(
            "These constraints do not match the naming convention and are not "
            "declared exceptions; later migrations drop constraints by their "
            f"convention name and will fail on them: {leftovers}"
        )

    log.info("normalise-constraints: renamed %d constraints", renamed)


def downgrade() -> None:
    pass
