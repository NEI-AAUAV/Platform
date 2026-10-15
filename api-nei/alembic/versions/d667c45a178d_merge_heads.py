"""merge heads

Revision ID: d667c45a178d
Revises: d6f8b0c2e4a7, b7d9f1a3c5e8
Create Date: 2026-09-28 17:07:38.699655

"""

from alembic import op
import sqlalchemy as sa

# revision identifiers, used by Alembic.
revision = "d667c45a178d"
down_revision = ("d6f8b0c2e4a7", "b7d9f1a3c5e8")
branch_labels = None
depends_on = None


def upgrade() -> None:
    pass


def downgrade() -> None:
    pass
