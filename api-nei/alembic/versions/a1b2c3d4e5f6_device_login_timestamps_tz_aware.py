"""Make device_login timestamps timezone-aware

Revision ID: a1b2c3d4e5f6
Revises: 3f1a2b4c5d6e
Create Date: 2026-08-18 00:00:00.000000

The USING clause is required for correctness, not syntax: without it
Postgres interprets the existing naive values in the session TimeZone at
ALTER time, which is the exact ambiguity being removed. Existing rows are
UTC wall times because db_pg runs with TimeZone=UTC — verify with
`SHOW TimeZone;` before applying to another deployment.

"""

from alembic import op
import sqlalchemy as sa


revision = "a1b2c3d4e5f6"
down_revision = "3f1a2b4c5d6e"
branch_labels = None
depends_on = None

_COLUMNS = ("refreshed_at", "expires_at")


def upgrade() -> None:
    for column in _COLUMNS:
        op.alter_column(
            "device_login",
            column,
            existing_type=sa.DateTime(),
            type_=sa.DateTime(timezone=True),
            existing_nullable=False,
            postgresql_using=f"{column} AT TIME ZONE 'UTC'",
            schema="nei",
        )


def downgrade() -> None:
    for column in _COLUMNS:
        op.alter_column(
            "device_login",
            column,
            existing_type=sa.DateTime(timezone=True),
            type_=sa.DateTime(),
            existing_nullable=False,
            postgresql_using=f"{column} AT TIME ZONE 'UTC'",
            schema="nei",
        )
