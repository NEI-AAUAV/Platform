"""Add oauth_state table for server-side PKCE state storage

Revision ID: b9e4c7f2a1d8
Revises: 3f1a2b4c5d6e
Create Date: 2026-06-17 00:00:00.000000

"""

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = "b9e4c7f2a1d8"
down_revision = "3f1a2b4c5d6e"
branch_labels = None
depends_on = None


def upgrade() -> None:
    op.create_table(
        "oauth_state",
        sa.Column("state", sa.String(), nullable=False),
        sa.Column("verifier", sa.String(), nullable=True),
        sa.Column("nonce", sa.String(), nullable=True),
        sa.Column("redirect", sa.String(), nullable=True),
        sa.Column("expires_at", sa.DateTime(), nullable=False),
        sa.PrimaryKeyConstraint("state", name=op.f("pk_oauth_state")),
        schema="nei",
    )
    op.create_index(
        op.f("ix_oauth_state_expires_at"),
        "oauth_state",
        ["expires_at"],
        unique=False,
        schema="nei",
    )


def downgrade() -> None:
    op.drop_index(
        op.f("ix_oauth_state_expires_at"),
        table_name="oauth_state",
        schema="nei",
    )
    op.drop_table("oauth_state", schema="nei")
