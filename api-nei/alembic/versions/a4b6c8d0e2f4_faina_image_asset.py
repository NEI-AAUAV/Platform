"""add faina.image_asset directus column

Revision ID: a4b6c8d0e2f4
Revises: c1d5e9a3f7b2
Create Date: 2026-09-18

Closes a gap between this Alembic chain and
Infrastructure/services/directus/sql/02-asset-columns.sql, which already
adds `faina.image_asset` on every Infrastructure deploy but had no Alembic
equivalent here. Same additive, nullable, no-FK pattern as
e8a1c9f3d6b7/a7c2e4f6b8d1: the legacy `faina.image` string column is left
untouched.
"""
from alembic import op
import sqlalchemy as sa

# revision identifiers, used by Alembic.
revision = "a4b6c8d0e2f4"
down_revision = "c1d5e9a3f7b2"
branch_labels = None
depends_on = None

SCHEMA = "nei"


def upgrade():
    # Infrastructure provisioning created this column out of band on some deployments.
    op.execute(f"ALTER TABLE {SCHEMA}.faina ADD COLUMN IF NOT EXISTS image_asset uuid")


def downgrade():
    op.drop_column("faina", "image_asset", schema=SCHEMA)
