"""add directus asset columns for file-bearing tables

NOTE (2026-09-18, superseded): this was previously also applied directly by
nei-directus/sql/02-asset-columns.sql on every deploy, on the assumption
this chain "couldn't run cleanly." That assumption no longer holds:
`alembic upgrade head` runs clean and idempotent on an empty database
(verified). Infrastructure's `sql/02-asset-columns.sql` has been removed;
this migration is now the sole source of truth for these columns.

Revision ID: e8a1c9f3d6b7
Revises: d3c7f0a1b2e4
Create Date: 2026-09-18

Adds one nullable `*_asset` UUID column per table that currently stores a
file as a plain string URL (`rgm.file`, `note.location`, `team_member.header`).
This is additive and non-destructive: the legacy string column is left
untouched, so api-nei and web-nei keep working exactly as before against
it. The new column is what Directus's File interface writes to once staff
upload a real file there (a UUID referencing a row in the `directus`
schema's `directus_files` table).

Deliberately NOT a real foreign key to `directus.directus_files`: that
would couple this migration's run order to the separate `nei-directus`
deployment (its schema must exist first) and couple two independently
deployed services at the DB-constraint level. Directus manages the
relation at the application level (`directus_relations`) regardless of
whether a Postgres FK backs it, so referential integrity here is enforced
by Directus, not Postgres. This is a deliberate looser-coupling trade,
consistent with `nei-directus` being a separate repo/service.

`api-nei`'s response schemas should prefer the `*_asset` column (resolved
via the `nei-directus` public URL) over the legacy string column once
populated, falling back to the legacy column when the asset is unset —
that serializer change is a separate step per table, not part of this
migration.
"""
from alembic import op
import sqlalchemy as sa

# revision identifiers, used by Alembic.
revision = "e8a1c9f3d6b7"
down_revision = "d3c7f0a1b2e4"
branch_labels = None
depends_on = None

SCHEMA = "nei"

ASSET_COLUMNS = [
    ("rgm", "file_asset"),
    ("note", "location_asset"),
    ("team_member", "header_asset"),
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
