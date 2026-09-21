"""Add nei.rgm_mandate and rgm.mandate_id, backfilled from DISTINCT rgm.mandate

Revision ID: c1d5e9a3f7b2
Revises: b8f3a1c9e2d4
Create Date: 2026-09-18 00:00:01.000000

Gives RGM its own mandate calendar as a real table (`rgm_mandate`), so the
Directus CMS can show one mandate's minutes ("atas") as an inline O2M list
instead of a flat, unfiltered table. RGM, team NEI and Comissão de Faina
each have independent mandate calendars — see
`Infrastructure/services/directus/sql/05-mandate-fks.sql`, which explicitly
undid a past mistake that FK'd `rgm.mandate` to `team_mandate.mandate`.
This migration does NOT repeat that mistake: `rgm_mandate` is its own
table, unrelated to `team_mandate`.

`rgm.mandate` (the legacy free-text column) is kept, NOT NULL, unchanged —
same `<field>` / `<field>_id` legacy-fallback pattern already used for
`rgm.file` / `rgm.file_asset`. Old rows and any code still reading the text
column are unaffected; Directus's `rgm` form demotes the text field to
readonly/hidden in favor of the new `mandate_id` dropdown.

Naming note: the FK is named `fk_rgm_mandate_id_rgm_mandate`, deliberately
NOT `fk_rgm_mandate_team_mandate` — that exact name is actively searched
for and dropped by `sql/05-mandate-fks.sql` on every deploy. Reusing it
would make this new FK vanish on the next `db-provision` run.
"""

from alembic import op
import sqlalchemy as sa


revision = "c1d5e9a3f7b2"
down_revision = "b8f3a1c9e2d4"
branch_labels = None
depends_on = None

SCHEMA = "nei"


def upgrade() -> None:
    op.create_table(
        "rgm_mandate",
        sa.Column("id", sa.Integer(), autoincrement=True, nullable=False),
        sa.Column("label", sa.String(length=7), nullable=False),
        sa.PrimaryKeyConstraint("id", name=op.f("pk_rgm_mandate")),
        sa.UniqueConstraint("label", name=op.f("uq_rgm_mandate_label")),
        schema=SCHEMA,
    )
    op.add_column(
        "rgm",
        sa.Column("mandate_id", sa.Integer(), nullable=True),
        schema=SCHEMA,
    )

    conn = op.get_bind()
    conn.execute(
        sa.text(
            f"INSERT INTO {SCHEMA}.rgm_mandate (label)"
            f" SELECT DISTINCT mandate FROM {SCHEMA}.rgm WHERE mandate IS NOT NULL"
        )
    )
    conn.execute(
        sa.text(
            f"UPDATE {SCHEMA}.rgm r SET mandate_id = m.id"
            f" FROM {SCHEMA}.rgm_mandate m WHERE m.label = r.mandate"
        )
    )

    op.create_foreign_key(
        op.f("fk_rgm_mandate_id_rgm_mandate"),
        "rgm",
        "rgm_mandate",
        ["mandate_id"],
        ["id"],
        source_schema=SCHEMA,
        referent_schema=SCHEMA,
        ondelete="SET NULL",
    )
    op.create_index(
        op.f("ix_nei_rgm_mandate_id"),
        "rgm",
        ["mandate_id"],
        unique=False,
        schema=SCHEMA,
    )


def downgrade() -> None:
    op.drop_index(op.f("ix_nei_rgm_mandate_id"), table_name="rgm", schema=SCHEMA)
    op.drop_constraint(
        op.f("fk_rgm_mandate_id_rgm_mandate"), "rgm", schema=SCHEMA, type_="foreignkey"
    )
    op.drop_column("rgm", "mandate_id", schema=SCHEMA)
    op.drop_table("rgm_mandate", schema=SCHEMA)
