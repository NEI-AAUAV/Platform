"""add directus asset columns for partner and merch

Revision ID: d7e9f1a3b5c7
Revises: c6d8e0f2a4b6
Create Date: 2026-09-18

Extends the same additive `*_asset` pattern used elsewhere (rgm, note,
team_member, news, history, video, faina) to `partner` and `merch`, which
previously had zero Directus support — only plain string URL columns.
Legacy string columns (`partner.header`, `partner.banner_image`,
`partner.banner_url`, `merch.image`) are left untouched; existing data is
not migrated automatically (there is no reliable way to turn an arbitrary
external URL into a Directus file UUID without re-uploading the actual
file — that backfill is deliberately deferred to a manual/one-off step).
"""
from alembic import op
import sqlalchemy as sa

# revision identifiers, used by Alembic.
revision = "d7e9f1a3b5c7"
down_revision = "c6d8e0f2a4b6"
branch_labels = None
depends_on = None

SCHEMA = "nei"

ASSET_COLUMNS = [
    ("partner", "header_asset"),
    ("partner", "banner_asset"),
    ("merch", "image_asset"),
]


def upgrade():
    # Infrastructure provisioning created these columns out of band on some deployments.
    for table, column in ASSET_COLUMNS:
        op.execute(
            f"ALTER TABLE {SCHEMA}.{table} ADD COLUMN IF NOT EXISTS {column} uuid"
        )


def downgrade():
    for table, column in ASSET_COLUMNS:
        op.drop_column(table, column, schema=SCHEMA)
