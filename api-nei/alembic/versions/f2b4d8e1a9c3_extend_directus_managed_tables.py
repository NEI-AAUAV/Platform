"""extend directus_svc grants to note and team_* tables

NOTE (2026-09-18): applied directly by nei-directus/sql/01-grants.sql on
every deploy — see d3c7f0a1b2e4's note for why.

Revision ID: f2b4d8e1a9c3
Revises: e8a1c9f3d6b7
Create Date: 2026-09-18

Onboards Apontamentos (`note`) and Equipa NEI (`team_mandate`,
`team_category`, `team_section`, `team_member`, `team_role`) into
`nei-directus`, following the same pattern as `rgm` in
d3c7f0a1b2e4_add_directus_readonly_db_role.py.

`team_colaborator` is deliberately NOT included: it has a composite
primary key (`user_id`, `mandate`), which Directus does not support for a
managed collection. Onboarding it would need a synthetic single-column
surrogate key added first — not done here.
"""
from alembic import op

# revision identifiers, used by Alembic.
revision = "f2b4d8e1a9c3"
down_revision = "e8a1c9f3d6b7"
branch_labels = None
depends_on = None

ROLE_NAME = "directus_svc"
APP_SCHEMA = "nei"

# (table, sequence) — sequence is None for tables without a surrogate
# integer PK (team_mandate's PK is the `mandate` string itself).
NEW_MANAGED_TABLES = [
    ("note", "note_id_seq"),
    ("team_mandate", None),
    ("team_category", "team_category_id_seq"),
    ("team_section", "team_section_id_seq"),
    ("team_member", "team_member_id_seq"),
    ("team_role", "team_role_id_seq"),
]


def upgrade():
    for table, sequence in NEW_MANAGED_TABLES:
        op.execute(
            f"GRANT SELECT, INSERT, UPDATE, DELETE ON {APP_SCHEMA}.{table} TO {ROLE_NAME};"
        )
        if sequence:
            op.execute(f"GRANT USAGE, SELECT ON {APP_SCHEMA}.{sequence} TO {ROLE_NAME};")


def downgrade():
    for table, sequence in NEW_MANAGED_TABLES:
        if sequence:
            op.execute(f"REVOKE USAGE, SELECT ON {APP_SCHEMA}.{sequence} FROM {ROLE_NAME};")
        op.execute(
            f"REVOKE SELECT, INSERT, UPDATE, DELETE ON {APP_SCHEMA}.{table} FROM {ROLE_NAME};"
        )
