"""database-level domain constraints for writes that bypass FastAPI

Revision ID: c3f5a7b9d1e2
Revises: c2e4a6b8d0f1
Create Date: 2026-09-19

Directus writes straight to PostgreSQL, so Pydantic validation never sees
its rows. True invariants therefore live in the schema:

* rgm.category IN ('ATA', 'PAO', 'RAC')
* merch.price >= 0, merch.number_of_items >= 0
* rgm_mandate.label and faina.mandate look like AAAA or AAAA/AA (the same
  pattern the API accepts as MandateStr)
* rgm.mandate_id is authoritative: NOT NULL, ON DELETE RESTRICT (a NOT NULL
  column cannot be SET NULL). The legacy text column rgm.mandate remains as a
  read fallback only.

Existing rows are checked first; a clear error lists offenders instead of a
generic constraint failure. Rows with a legacy mandate text but no mandate_id
are linked (creating the rgm_mandate row when needed).
"""

from alembic import op
import sqlalchemy as sa


revision = "c3f5a7b9d1e2"
down_revision = "c2e4a6b8d0f1"
branch_labels = None
depends_on = None

S = "nei"
MANDATE_RE = "~ '^[0-9]{4}(/[0-9]{2})?$'"

CHECKS = [
    ("rgm", "category_valid", "category IN ('ATA', 'PAO', 'RAC')"),
    ("merch", "price_non_negative", "price >= 0"),
    ("merch", "number_of_items_non_negative", "number_of_items >= 0"),
    ("rgm_mandate", "label_format", f"label {MANDATE_RE}"),
    ("faina", "mandate_format", f"mandate {MANDATE_RE}"),
]


def _fail_on(conn, table: str, name: str, expr: str) -> None:
    bad = conn.execute(
        sa.text(f"SELECT id FROM {S}.{table} WHERE NOT COALESCE(({expr}), TRUE)")
    ).scalars().all()
    if bad:
        raise RuntimeError(
            f"{table} rows violating {name} ({expr}): ids {bad}. Fix them before migrating."
        )


def upgrade() -> None:
    conn = op.get_bind()

    conn.execute(
        sa.text(
            f"INSERT INTO {S}.rgm_mandate (label) SELECT DISTINCT mandate FROM {S}.rgm"
            f" WHERE mandate_id IS NULL AND mandate IS NOT NULL"
            f" AND mandate NOT IN (SELECT label FROM {S}.rgm_mandate)"
        )
    )
    conn.execute(
        sa.text(
            f"UPDATE {S}.rgm r SET mandate_id = m.id FROM {S}.rgm_mandate m"
            " WHERE r.mandate_id IS NULL AND m.label = r.mandate"
        )
    )
    unlinked = conn.execute(
        sa.text(f"SELECT id FROM {S}.rgm WHERE mandate_id IS NULL")
    ).scalars().all()
    if unlinked:
        raise RuntimeError(f"rgm rows with no mandate at all: {unlinked}.")

    for table, name, expr in CHECKS:
        _fail_on(conn, table, name, expr)

    op.alter_column("rgm", "mandate_id", nullable=False, schema=S)
    op.drop_constraint(
        op.f("fk_rgm_mandate_id_rgm_mandate"), "rgm", schema=S, type_="foreignkey"
    )
    op.create_foreign_key(
        op.f("fk_rgm_mandate_id_rgm_mandate"),
        "rgm",
        "rgm_mandate",
        ["mandate_id"],
        ["id"],
        source_schema=S,
        referent_schema=S,
        ondelete="RESTRICT",
    )
    for table, name, expr in CHECKS:
        op.create_check_constraint(op.f(f"ck_{table}_{name}"), table, expr, schema=S)


def downgrade() -> None:
    for table, name, _ in reversed(CHECKS):
        op.drop_constraint(op.f(f"ck_{table}_{name}"), table, schema=S, type_="check")
    op.drop_constraint(
        op.f("fk_rgm_mandate_id_rgm_mandate"), "rgm", schema=S, type_="foreignkey"
    )
    op.create_foreign_key(
        op.f("fk_rgm_mandate_id_rgm_mandate"),
        "rgm",
        "rgm_mandate",
        ["mandate_id"],
        ["id"],
        source_schema=S,
        referent_schema=S,
        ondelete="SET NULL",
    )
    op.alter_column("rgm", "mandate_id", nullable=True, schema=S)
