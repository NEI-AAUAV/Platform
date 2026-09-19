"""retired: directus least-privilege db role

Revision ID: d3c7f0a1b2e4
Revises: d4e5f6a7b8c9
Create Date: 2026-09-18

RETIRED (Directus phase 2): this revision used to create the directus_svc role/`directus` schema and grant it access to nei.rgm.
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
revision = "d3c7f0a1b2e4"
down_revision = "d4e5f6a7b8c9"
branch_labels = None
depends_on = None


def upgrade():
    pass


def downgrade():
    pass
