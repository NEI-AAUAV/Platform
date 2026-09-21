"""Add team_member.mandate, backfilled from section -> category -> mandate

SUPERSEDED by a2c4e6f8b0d1, which drops this column again: it was a
denormalization added only for a Directus O2M list and is not part of the
domain model. Kept in the chain so applied databases stay valid.

Revision ID: b8f3a1c9e2d4
Revises: a7c2e4f6b8d1
Create Date: 2026-09-18 00:00:00.000000

Lets the Directus CMS show every team member of a mandate in one inline
list (`team_mandate.members`, an O2M) instead of requiring editors to walk
category -> section -> member as three separate screens. See
`Infrastructure/services/directus/README.md`'s "Equipa NEI" notes.

`mandate` is deliberately nullable and does NOT replace `section_id`, which
remains the authoritative link (NOT NULL, still required on create). This
column is a denormalized convenience for the CMS's flat list; it can drift
from `section_id`'s actual mandate if a member is ever repointed to a
section under a different mandate. The Directus field is configured
read-only to avoid that in practice — see fields.yaml's `team_member.mandate`.

Naming note: `team_member.mandate` and its FK/index existed before
migration c3d4e5f6a7b8 restructured the team into mandate -> category ->
section -> member, and were dropped there in favor of the section_id chain
(see that migration's `upgrade()`). This migration reintroduces the same
column name, now as an additive, non-authoritative denormalization
alongside section_id rather than a replacement for it.
"""

from alembic import op
import sqlalchemy as sa


revision = "b8f3a1c9e2d4"
down_revision = "a7c2e4f6b8d1"
branch_labels = None
depends_on = None

SCHEMA = "nei"


def upgrade() -> None:
    op.add_column(
        "team_member",
        sa.Column("mandate", sa.String(length=7), nullable=True),
        schema=SCHEMA,
    )

    conn = op.get_bind()
    conn.execute(
        sa.text(
            f"UPDATE {SCHEMA}.team_member m SET mandate = c.mandate"
            f" FROM {SCHEMA}.team_section s"
            f" JOIN {SCHEMA}.team_category c ON c.id = s.category_id"
            " WHERE s.id = m.section_id"
        )
    )

    op.create_foreign_key(
        op.f("fk_team_member_mandate_team_mandate"),
        "team_member",
        "team_mandate",
        ["mandate"],
        ["mandate"],
        source_schema=SCHEMA,
        referent_schema=SCHEMA,
        ondelete="CASCADE",
    )
    op.create_index(
        op.f("ix_nei_team_member_mandate"),
        "team_member",
        ["mandate"],
        unique=False,
        schema=SCHEMA,
    )


def downgrade() -> None:
    op.drop_index(op.f("ix_nei_team_member_mandate"), table_name="team_member", schema=SCHEMA)
    op.drop_constraint(
        op.f("fk_team_member_mandate_team_mandate"),
        "team_member",
        schema=SCHEMA,
        type_="foreignkey",
    )
    op.drop_column("team_member", "mandate", schema=SCHEMA)
