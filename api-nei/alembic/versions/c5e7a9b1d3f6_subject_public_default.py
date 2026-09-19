"""subject.public defaults to false

Revision ID: c5e7a9b1d3f6
Revises: b4d6f8a0c2e5
Create Date: 2026-09-19

`subject.public` is NOT NULL but had no database default (only a Python-side
one), so a subject created from the CMS was rejected with "public: O valor é
obrigatório". Nothing in the API reads the flag.
"""
from alembic import op

from app.core.config import settings

revision = "c5e7a9b1d3f6"
down_revision = "b4d6f8a0c2e5"
branch_labels = None
depends_on = None

S = settings.SCHEMA_NAME


def upgrade():
    op.execute(f"ALTER TABLE {S}.subject ALTER COLUMN public SET DEFAULT false")


def downgrade():
    op.execute(f"ALTER TABLE {S}.subject ALTER COLUMN public DROP DEFAULT")
