"""existing news rows are already public: mark them published

Revision ID: a3c5e7b9d1f4
Revises: c3f5a7b9d1e2
Create Date: 2026-09-19

`news.public` has existed since the initial schema but no endpoint ever
filtered on it, so every row was served regardless of its value. Now that the
public list and detail endpoints honour the flag -- and the CMS presents it as
a publish toggle -- every pre-existing row must be marked published, otherwise
enabling the filter would empty the news page.

Rows created from here on default to false (see b9d1f3a5c7e8) and have to be
published explicitly.

The downgrade is a no-op: once this has run there is no way to tell a
backfilled row from one an editor published by hand.
"""
from alembic import op

from app.core.config import settings

revision = "a3c5e7b9d1f4"
down_revision = "c3f5a7b9d1e2"
branch_labels = None
depends_on = None

S = settings.SCHEMA_NAME


def upgrade():
    op.execute(f"UPDATE {S}.news SET public = true WHERE public IS NOT true")


def downgrade():
    pass
