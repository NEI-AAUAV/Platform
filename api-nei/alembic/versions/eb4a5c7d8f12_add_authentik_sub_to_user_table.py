"""Add authentik_sub column to user table for OIDC integration

Revision ID: eb4a5c7d8f12
Revises: caaa223a3654
Create Date: 2026-02-02 18:42:26.000000

"""

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = "eb4a5c7d8f12"
down_revision = "caaa223a3654"
branch_labels = None
depends_on = None


def upgrade() -> None:
    # Add authentik_sub column for OIDC integration
    op.add_column(
        "user",
        sa.Column("authentik_sub", sa.String(length=255), nullable=True),
        schema="nei",
    )
    
    # Add unique constraint to prevent multiple accounts with same Authentik ID
    op.create_unique_constraint(
        op.f("uq_user_authentik_sub"),
        "user",
        ["authentik_sub"],
        schema="nei",
    )
    
    # Make hashed_password nullable to support OIDC-only users
    op.alter_column(
        "user",
        "hashed_password",
        existing_type=sa.Text(),
        nullable=True,
        schema="nei",
    )


def downgrade() -> None:
    # Revert hashed_password to non-nullable
    # Note: This will fail if there are OIDC users without passwords
    op.alter_column(
        "user",
        "hashed_password",
        existing_type=sa.Text(),
        nullable=False,
        schema="nei",
    )
    
    # Drop unique constraint
    op.drop_constraint(
        op.f("uq_user_authentik_sub"),
        "user",
        schema="nei",
        type_="unique",
    )
    
    # Drop authentik_sub column
    op.drop_column("user", "authentik_sub", schema="nei")
