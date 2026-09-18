"""Allow faina elements without a linked user

Revision ID: d4e5f6a7b8c9
Revises: c3d4e5f6a7b8
Create Date: 2026-09-09 00:00:00.000000

The commission is often made up of people who have no account on the
platform, so an element can now carry a plain name instead of a user id.

"""

from alembic import op
import sqlalchemy as sa


revision = "d4e5f6a7b8c9"
down_revision = "c3d4e5f6a7b8"
branch_labels = None
depends_on = None

SCHEMA = "nei"


def upgrade() -> None:
    op.add_column(
        "faina_member",
        sa.Column("name", sa.String(length=120), nullable=True),
        schema=SCHEMA,
    )


def downgrade() -> None:
    op.drop_column("faina_member", "name", schema=SCHEMA)
