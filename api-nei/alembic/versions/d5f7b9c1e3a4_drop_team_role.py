"""drop team_role

Revision ID: d5f7b9c1e3a4
Revises: c4e6a8b0d2f3
Create Date: 2026-09-19

`team_member.role_id` was replaced by the free-text `team_member.role` in
c3d4e5f6a7b8, so nothing references `team_role` any more. It survived only as
an orphan collection (editable, but with no effect on any team member). The
table, its API endpoints (/team/role) and its frontend service call are
removed.

Downgrade recreates the empty table; the previous rows were only ever
consulted by the old weight-based grouping and are not restored.
"""

from alembic import op
import sqlalchemy as sa


revision = "d5f7b9c1e3a4"
down_revision = "c4e6a8b0d2f3"
branch_labels = None
depends_on = None

SCHEMA = "nei"


def upgrade() -> None:
    op.drop_index(op.f("ix_nei_team_role_weight"), table_name="team_role", schema=SCHEMA)
    op.drop_table("team_role", schema=SCHEMA)


def downgrade() -> None:
    op.create_table(
        "team_role",
        sa.Column("id", sa.Integer(), autoincrement=True, nullable=False),
        sa.Column("name", sa.String(length=120), nullable=True),
        sa.Column("weight", sa.Integer(), nullable=False),
        sa.PrimaryKeyConstraint("id", name=op.f("pk_team_role")),
        schema=SCHEMA,
    )
    op.create_index(
        op.f("ix_nei_team_role_weight"), "team_role", ["weight"], schema=SCHEMA
    )
