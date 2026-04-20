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
    # WARNING: This downgrade is effectively one-way for OIDC-only users.
    #
    # OIDC-only users have NULL hashed_password. Reverting hashed_password to
    # NOT NULL requires writing *something* to those rows — we use a
    # placeholder that cannot match any bcrypt verify. A re-upgrade does NOT
    # restore the original NULLs; those users now have a garbage hash and
    # (since authentik_sub is dropped below) no way back into their account
    # except a password reset via email.
    #
    # Before running this in production:
    #   1. Snapshot the database.
    #   2. Either send password-reset emails to every OIDC-only user first,
    #      or communicate the outage to users.
    #   3. Expect to manually reconcile authentik_sub after re-upgrade.
    bind = op.get_bind()
    bind.execute(
        sa.text(
            "UPDATE nei.\"user\" SET hashed_password = '!oidc-placeholder!' "
            "WHERE hashed_password IS NULL"
        )
    )

    op.alter_column(
        "user",
        "hashed_password",
        existing_type=sa.Text(),
        nullable=False,
        schema="nei",
    )

    op.drop_constraint(
        op.f("uq_user_authentik_sub"),
        "user",
        schema="nei",
        type_="unique",
    )

    op.drop_column("user", "authentik_sub", schema="nei")
