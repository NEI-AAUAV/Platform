"""retired: directus grants for faina/video/partner/merch

Revision ID: e8f0a2b4c6d8
Revises: d7e9f1a3b5c7
Create Date: 2026-09-18

RETIRED (Directus phase 2): this revision used to grant directus_svc access to faina, video, partner and merch tables.
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
revision = "e8f0a2b4c6d8"
down_revision = "d7e9f1a3b5c7"
branch_labels = None
depends_on = None


def upgrade():
    pass


def downgrade():
    pass
