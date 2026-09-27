"""admin_activity log and user.last_login_at

Revision ID: d6f8b0c2e4a7
Revises: c5e7a9b1d3f6
Create Date: 2026-09-27

Records what admins change (roles, sign-outs, Arraial) and when each user last
signed in; device_login rows are deleted on expiry, so they can't answer that.
"""
import sqlalchemy as sa
from alembic import op
from sqlalchemy.dialects import postgresql

from app.core.config import settings

revision = "d6f8b0c2e4a7"
down_revision = "c5e7a9b1d3f6"
branch_labels = None
depends_on = None

S = settings.SCHEMA_NAME


def upgrade():
    op.add_column(
        "user",
        sa.Column("last_login_at", sa.DateTime(timezone=True), nullable=True),
        schema=S,
    )
    op.create_table(
        "admin_activity",
        sa.Column("id", sa.Integer(), primary_key=True, autoincrement=True),
        sa.Column("created_at", sa.DateTime(timezone=True), nullable=False),
        # No foreign keys: the log must outlive the accounts it mentions.
        sa.Column("actor_id", sa.Integer(), nullable=True),
        sa.Column("actor_name", sa.String(41), nullable=True),
        sa.Column("action", sa.String(50), nullable=False),
        sa.Column("target_user_id", sa.Integer(), nullable=True),
        sa.Column("target_name", sa.String(41), nullable=True),
        sa.Column("detail", postgresql.JSONB(), nullable=True),
        schema=S,
    )
    op.create_index(
        "ix_nei_admin_activity_created_at", "admin_activity", ["created_at"], schema=S
    )


def downgrade():
    op.drop_index("ix_nei_admin_activity_created_at", table_name="admin_activity", schema=S)
    op.drop_table("admin_activity", schema=S)
    op.drop_column("user", "last_login_at", schema=S)
