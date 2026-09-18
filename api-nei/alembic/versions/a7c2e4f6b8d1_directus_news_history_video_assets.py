"""add directus asset columns for news/history/video + video tags junction PK

Revision ID: a7c2e4f6b8d1
Revises: f2b4d8e1a9c3
Create Date: 2026-09-18

Extends the same additive `*_asset` pattern from e8a1c9f3d6b7 to the three
content areas onboarded into nei-directus in this pass: `news.header`,
`history.image`, `video.image`. Also gives `video__video_tags` (the M2M
junction between `video` and `video_tag`) a surrogate `id` primary key,
for the same reason team_colaborator needed one in a prior migration:
Directus does not introspect a table with a composite primary key as a
collection at all, and `video.tags` (config/fields.yaml in nei-directus)
is an M2M field through this junction. The old (video_id, mandate)... err,
(video_id, video_tag_id) pair is preserved as a UNIQUE constraint, so
nothing that queried by that pair breaks.

As with d3c7f0a1b2e4/e8a1c9f3d6b7/f2b4d8e1a9c3, the corresponding grants
for these new tables/columns are applied by nei-directus/sql/*.sql on its
own deploy (that repo's `db-provision` service), not by this migration —
see that repo's README for why (this local Alembic chain currently can't
run cleanly against the dev database; nei-directus/sql/ is the practical
source of truth for DDL affecting directus_svc access until that's
reconciled). This migration documents the "official" schema history.
"""
from alembic import op
import sqlalchemy as sa

# revision identifiers, used by Alembic.
revision = "a7c2e4f6b8d1"
down_revision = "f2b4d8e1a9c3"
branch_labels = None
depends_on = None

SCHEMA = "nei"

ASSET_COLUMNS = [
    ("news", "header_asset"),
    ("history", "image_asset"),
    ("video", "image_asset"),
]


def upgrade():
    for table, column in ASSET_COLUMNS:
        op.add_column(
            table,
            sa.Column(column, sa.dialects.postgresql.UUID(as_uuid=True), nullable=True),
            schema=SCHEMA,
        )

    op.add_column(
        "video__video_tags",
        sa.Column("id", sa.BigInteger(), nullable=True),
        schema=SCHEMA,
    )
    op.execute(
        f"""
        CREATE SEQUENCE IF NOT EXISTS {SCHEMA}.video__video_tags_id_seq
            OWNED BY {SCHEMA}.video__video_tags.id;
        SELECT setval(
            '{SCHEMA}.video__video_tags_id_seq',
            COALESCE((SELECT max(id) FROM {SCHEMA}.video__video_tags), 0) + 1,
            false
        );
        ALTER TABLE {SCHEMA}.video__video_tags
            ALTER COLUMN id SET DEFAULT nextval('{SCHEMA}.video__video_tags_id_seq');
        UPDATE {SCHEMA}.video__video_tags SET id = nextval('{SCHEMA}.video__video_tags_id_seq')
            WHERE id IS NULL;
        ALTER TABLE {SCHEMA}.video__video_tags ALTER COLUMN id SET NOT NULL;
        ALTER TABLE {SCHEMA}.video__video_tags DROP CONSTRAINT IF EXISTS pk_video__video_tags;
        ALTER TABLE {SCHEMA}.video__video_tags
            ADD CONSTRAINT uq_video__video_tags_video_tag UNIQUE (video_id, video_tag_id);
        ALTER TABLE {SCHEMA}.video__video_tags ADD CONSTRAINT pk_video__video_tags_id PRIMARY KEY (id);
        """
    )


def downgrade():
    op.execute(
        f"""
        ALTER TABLE {SCHEMA}.video__video_tags DROP CONSTRAINT IF EXISTS pk_video__video_tags_id;
        ALTER TABLE {SCHEMA}.video__video_tags DROP CONSTRAINT IF EXISTS uq_video__video_tags_video_tag;
        ALTER TABLE {SCHEMA}.video__video_tags ADD CONSTRAINT pk_video__video_tags PRIMARY KEY (video_id, video_tag_id);
        DROP SEQUENCE IF EXISTS {SCHEMA}.video__video_tags_id_seq;
        """
    )
    op.drop_column("video__video_tags", "id", schema=SCHEMA)

    for table, column in ASSET_COLUMNS:
        op.drop_column(table, column, schema=SCHEMA)
