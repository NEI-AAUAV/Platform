"""grant directus_svc access to team_colaborator

Revision ID: f9a1b3c5d7e9
Revises: e8f0a2b4c6d8
Create Date: 2026-09-18

f2b4d8e1a9c3 deliberately excluded `team_colaborator` from directus_svc's
grants because it had a composite primary key, which Directus can't
manage. b5c7d9e1f3a5 fixed that (added a surrogate `id` PK) but never
actually granted the table — closing that gap here, following the same
pattern as e8f0a2b4c6d8.
"""
from alembic import op

# revision identifiers, used by Alembic.
revision = "f9a1b3c5d7e9"
down_revision = "e8f0a2b4c6d8"
branch_labels = None
depends_on = None

ROLE_NAME = "directus_svc"
APP_SCHEMA = "nei"
TABLE = "team_colaborator"
SEQUENCE = "team_colaborator_id_seq"


def upgrade():
    op.execute(f"GRANT SELECT, INSERT, UPDATE, DELETE ON {APP_SCHEMA}.{TABLE} TO {ROLE_NAME};")
    op.execute(f"GRANT USAGE, SELECT ON {APP_SCHEMA}.{SEQUENCE} TO {ROLE_NAME};")


def downgrade():
    op.execute(f"REVOKE USAGE, SELECT ON {APP_SCHEMA}.{SEQUENCE} FROM {ROLE_NAME};")
    op.execute(f"REVOKE SELECT, INSERT, UPDATE, DELETE ON {APP_SCHEMA}.{TABLE} FROM {ROLE_NAME};")
