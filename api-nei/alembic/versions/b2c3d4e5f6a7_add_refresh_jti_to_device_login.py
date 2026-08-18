"""Add refresh_jti to device_login for refresh-token replay detection

Revision ID: b2c3d4e5f6a7
Revises: a1b2c3d4e5f6
Create Date: 2026-08-18 00:00:00.000000

Nullable with no server default, so this is metadata-only on PG 11+ and
does not rewrite the table. Sessions created before this migration have a
NULL jti and fall back to the old timestamp check for exactly one
rotation; see _validate_refresh_token. Every such row is gone within
REFRESH_TOKEN_EXPIRE, after which a follow-up migration should make the
column NOT NULL and the fallback branch should be deleted.

"""

from alembic import op
import sqlalchemy as sa


revision = "b2c3d4e5f6a7"
down_revision = "a1b2c3d4e5f6"
branch_labels = None
depends_on = None


def upgrade() -> None:
    op.add_column(
        "device_login",
        sa.Column("refresh_jti", sa.String(length=64), nullable=True),
        schema="nei",
    )


def downgrade() -> None:
    op.drop_column("device_login", "refresh_jti", schema="nei")
