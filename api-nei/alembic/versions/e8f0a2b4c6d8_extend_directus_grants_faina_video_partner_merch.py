"""extend directus_svc grants to remaining onboarded content tables

Revision ID: e8f0a2b4c6d8
Revises: d7e9f1a3b5c7
Create Date: 2026-09-18

Closes the remaining grants gap between this Alembic chain and
Infrastructure/services/directus/sql/01-grants.sql +
07-rgm-mandate.sql: these tables already have `*_asset`/`mandate_id`
columns and are onboarded in `config/access.yaml`/`fields.yaml`, but
`directus_svc` was only ever granted access to them by Infrastructure's
own SQL, never by Alembic (`video`, `news`, `history` were never granted
by any prior migration either — not just the tables added in this pass).
Follows the same pattern as f2b4d8e1a9c3.
"""
from alembic import op

# revision identifiers, used by Alembic.
revision = "e8f0a2b4c6d8"
down_revision = "d7e9f1a3b5c7"
branch_labels = None
depends_on = None

ROLE_NAME = "directus_svc"
APP_SCHEMA = "nei"

NEW_MANAGED_TABLES = [
    ("news", "news_id_seq"),
    ("history", None),  # PK is `moment` (Date), no surrogate sequence
    ("video", "video_id_seq"),
    ("video_tag", "video_tag_id_seq"),
    ("video__video_tags", "video__video_tags_id_seq"),
    ("faina", "faina_id_seq"),
    ("faina_role", "faina_role_id_seq"),
    ("faina_member", "faina_member_id_seq"),
    ("partner", "partner_id_seq"),
    ("merch", "merch_id_seq"),
    ("rgm_mandate", "rgm_mandate_id_seq"),
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
