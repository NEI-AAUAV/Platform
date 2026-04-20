"""Add oidc_id_token column to device_login table

Revision ID: 3f1a2b4c5d6e
Revises: eb4a5c7d8f12
Create Date: 2026-03-30 00:00:00.000000

"""

from alembic import op
import sqlalchemy as sa


revision = "3f1a2b4c5d6e"
down_revision = "eb4a5c7d8f12"
branch_labels = None
depends_on = None


def upgrade() -> None:
    op.add_column(
        "device_login",
        sa.Column("oidc_id_token", sa.Text(), nullable=True),
        schema="nei",
    )


def downgrade() -> None:
    op.drop_column("device_login", "oidc_id_token", schema="nei")
