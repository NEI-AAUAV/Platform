"""retired: team_colaborator surrogate primary key

Revision ID: b5c7d9e1f3a5
Revises: a4b6c8d0e2f4
Create Date: 2026-09-18

RETIRED (Directus phase 2): this revision used to replace team_colaborator's composite (user_id, mandate) primary key with a surrogate `id` purely because Directus cannot manage composite keys. The domain model must not bend to CMS limits; team_colaborator is now migrated into team_member and dropped (see the team_colaborator_to_member revision).
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
revision = "b5c7d9e1f3a5"
down_revision = "a4b6c8d0e2f4"
branch_labels = None
depends_on = None


def upgrade():
    pass


def downgrade():
    pass
