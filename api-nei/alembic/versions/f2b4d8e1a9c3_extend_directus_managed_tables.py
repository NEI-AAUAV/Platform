"""retired: directus grants for note and team tables

Revision ID: f2b4d8e1a9c3
Revises: e8a1c9f3d6b7
Create Date: 2026-09-18

RETIRED (Directus phase 2): this revision used to grant directus_svc access to note and team_* tables.
That is Directus infrastructure, not application schema, and is now owned by
the Infrastructure repository (services/directus: sql/01-roles-schema.sql and
sql/02-table-grants.sql, driven by managed-tables.txt).

The revision id is kept so the Alembic graph stays linear and any database
that already applied it (developer/staging databases; this revision never
reached `main`) keeps a valid `alembic_version`. It is intentionally a no-op:
grants that were already applied are reconciled by Infrastructure's
provisioning on the next Directus deploy.
"""
from alembic import op  # noqa: F401

# revision identifiers, used by Alembic.
revision = "f2b4d8e1a9c3"
down_revision = "e8a1c9f3d6b7"
branch_labels = None
depends_on = None


def upgrade():
    pass


def downgrade():
    pass
