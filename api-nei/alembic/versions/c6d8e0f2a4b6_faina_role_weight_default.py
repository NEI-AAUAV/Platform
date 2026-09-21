"""give faina_role.weight a safe default

Revision ID: c6d8e0f2a4b6
Revises: b5c7d9e1f3a5
Create Date: 2026-09-18

`faina_role.weight` is NOT NULL with no default, so creating a role from
Directus fails unless the editor manually supplies an arbitrary ordering
number. Give it `server_default=0` so creation always succeeds; ordering
can still be adjusted afterwards (ideally via a reorder/drag-and-drop
Directus UI, not a required field on create).
"""
from alembic import op
import sqlalchemy as sa

# revision identifiers, used by Alembic.
revision = "c6d8e0f2a4b6"
down_revision = "b5c7d9e1f3a5"
branch_labels = None
depends_on = None

SCHEMA = "nei"


def upgrade():
    op.alter_column(
        "faina_role",
        "weight",
        server_default=sa.text("0"),
        schema=SCHEMA,
    )


def downgrade():
    op.alter_column(
        "faina_role",
        "weight",
        server_default=None,
        schema=SCHEMA,
    )
