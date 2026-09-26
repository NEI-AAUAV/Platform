"""history: editorial fields + history_media gallery table

Revision ID: a3f5c7e9b1d4
Revises: c5e7a9b1d3f6
Create Date: 2026-09-26

Extends `history` for the public timeline redesign:
- `category`: free-slug editorial tag (fundacao/evento/conquista/mandato/
  infraestrutura/outro), validated in Directus, not the DB.
- `featured`, `published`: booleans, default false/true so existing rows
  stay visible.
- `external_url` + `external_label`: optional related link (news/video/...).
- `mandate`: free-text academic year ("2025/26"); the API derives one from
  `moment` when this is blank, so it is never required.
- `drive_folder_url`: opaque URL to a shared Google Drive folder; api-nei
  only resolves it at read time (app/integrations/google_drive.py) and
  never validates its shape here.

Adds `history_media`, one gallery photo per row: either a Directus upload
(`photo_asset`) or a single Drive file link (`drive_url`), never both — enforced
by `ck_history_media_single_source`. Ordered by `weight` (drag-to-reorder
in Directus). `ON DELETE CASCADE` so deleting a milestone drops its photos.

Grants for `directus_svc` on `history_media` and the new columns are not
part of this migration: since e8f0a2b4c6d8, Directus-facing grants are
owned by Infrastructure (services/directus: managed-tables.txt +
sql/02-table-grants.sql), not Alembic.
"""
from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import postgresql

# revision identifiers, used by Alembic.
revision = "a3f5c7e9b1d4"
down_revision = "c5e7a9b1d3f6"
branch_labels = None
depends_on = None

SCHEMA = "nei"


def upgrade():
    op.add_column("history", sa.Column("category", sa.String(20), nullable=True), schema=SCHEMA)
    op.add_column(
        "history",
        sa.Column("featured", sa.Boolean(), nullable=False, server_default=sa.false()),
        schema=SCHEMA,
    )
    op.add_column(
        "history",
        sa.Column("published", sa.Boolean(), nullable=False, server_default=sa.true()),
        schema=SCHEMA,
    )
    op.add_column("history", sa.Column("external_url", sa.String(2048), nullable=True), schema=SCHEMA)
    op.add_column("history", sa.Column("external_label", sa.String(60), nullable=True), schema=SCHEMA)
    op.add_column("history", sa.Column("mandate", sa.String(7), nullable=True), schema=SCHEMA)
    op.add_column("history", sa.Column("drive_folder_url", sa.String(2048), nullable=True), schema=SCHEMA)

    op.create_table(
        "history_media",
        sa.Column("id", sa.BigInteger(), primary_key=True, autoincrement=True),
        sa.Column("history_id", sa.BigInteger(), nullable=False),
        sa.Column("photo_asset", postgresql.UUID(as_uuid=True), nullable=True),
        sa.Column("drive_url", sa.String(2048), nullable=True),
        sa.Column("caption", sa.String(200), nullable=True),
        sa.Column("weight", sa.Integer(), nullable=False, server_default="0"),
        sa.ForeignKeyConstraint(
            ["history_id"], [f"{SCHEMA}.history.id"],
            name="fk_history_media_history_id_history",
            ondelete="CASCADE",
        ),
        sa.CheckConstraint(
            "(photo_asset IS NULL) <> (drive_url IS NULL)",
            name="ck_history_media_single_source",
        ),
        schema=SCHEMA,
    )
    op.create_index(
        op.f("ix_nei_history_media_history_id"),
        "history_media",
        ["history_id"],
        schema=SCHEMA,
    )


def downgrade():
    op.drop_index(op.f("ix_nei_history_media_history_id"), table_name="history_media", schema=SCHEMA)
    op.drop_table("history_media", schema=SCHEMA)

    op.drop_column("history", "drive_folder_url", schema=SCHEMA)
    op.drop_column("history", "mandate", schema=SCHEMA)
    op.drop_column("history", "external_label", schema=SCHEMA)
    op.drop_column("history", "external_url", schema=SCHEMA)
    op.drop_column("history", "published", schema=SCHEMA)
    op.drop_column("history", "featured", schema=SCHEMA)
    op.drop_column("history", "category", schema=SCHEMA)
