"""history: CMS-managed category table

Revision ID: e2b4d6f8a1c3
Revises: a3f5c7e9b1d4
Create Date: 2026-09-27

Replaces `history.category` (a free string, validated only client-side in
Directus — see the removed `HistoryCategory` Literal in schemas/history.py)
with a proper lookup table + FK. A hardcoded enum meant adding, renaming or
recoloring a category needed a code deploy; `history_category` is a normal
CMS collection, editable from Directus like any other content.

`ON DELETE SET NULL`: deleting a category from the CMS un-categorizes its
milestones instead of cascading into the timeline.

Seeds the six categories the old enum had, so existing/dev data and the
frontend's filter chips keep working unchanged after the migration —
`color` matches the current hardcoded `CATEGORY_META` in web-nei, now
CMS-editable instead of hardcoded.

Grants for `directus_svc` on `history_category` are not part of this
migration — see a3f5c7e9b1d4's note; owned by Infrastructure
(managed-tables.txt), not Alembic.
"""
from alembic import op
import sqlalchemy as sa

# revision identifiers, used by Alembic.
revision = "e2b4d6f8a1c3"
down_revision = "a3f5c7e9b1d4"
branch_labels = None
depends_on = None

SCHEMA = "nei"

SEED_CATEGORIES = [
    (1, "fundacao", "Fundação", "hsl(145 80% 35%)"),
    (2, "evento", "Evento", "hsl(210 90% 55%)"),
    (3, "conquista", "Conquista", "hsl(38 92% 50%)"),
    (4, "mandato", "Mandato", "hsl(280 65% 60%)"),
    (5, "infraestrutura", "Infraestrutura", "hsl(160 60% 40%)"),
    (6, "outro", "Outro", "hsl(220 9% 46%)"),
]

history_category = sa.table(
    "history_category",
    sa.column("id", sa.BigInteger),
    sa.column("slug", sa.String),
    sa.column("label", sa.String),
    sa.column("color", sa.String),
    sa.column("weight", sa.Integer),
    schema=SCHEMA,
)

history = sa.table(
    "history",
    sa.column("category_id", sa.BigInteger),
    sa.column("category", sa.String),
    schema=SCHEMA,
)


def upgrade():
    op.create_table(
        "history_category",
        sa.Column("id", sa.BigInteger(), primary_key=True, autoincrement=True),
        sa.Column("slug", sa.String(30), nullable=False),
        sa.Column("label", sa.String(60), nullable=False),
        sa.Column("color", sa.String(60), nullable=True),
        sa.Column("weight", sa.Integer(), nullable=False, server_default="0"),
        sa.UniqueConstraint("slug", name=op.f("uq_history_category_slug")),
        schema=SCHEMA,
    )

    op.bulk_insert(
        history_category,
        [
            {"id": id_, "slug": slug, "label": label, "color": color, "weight": i}
            for i, (id_, slug, label, color) in enumerate(SEED_CATEGORIES)
        ],
    )
    # bulk_insert with explicit ids doesn't advance the identity sequence —
    # the next plain INSERT (any Directus-created category) would collide.
    op.execute(
        f"SELECT setval(pg_get_serial_sequence('{SCHEMA}.history_category', 'id'), "
        f"(SELECT max(id) FROM {SCHEMA}.history_category))"
    )

    op.add_column("history", sa.Column("category_id", sa.BigInteger(), nullable=True), schema=SCHEMA)
    op.create_foreign_key(
        "fk_history_category_id_history_category",
        "history",
        "history_category",
        ["category_id"],
        ["id"],
        source_schema=SCHEMA,
        referent_schema=SCHEMA,
        ondelete="SET NULL",
    )
    op.create_index(
        op.f("ix_nei_history_category_id"),
        "history",
        ["category_id"],
        schema=SCHEMA,
    )

    conn = op.get_bind()
    for _, slug, _, _ in SEED_CATEGORIES:
        conn.execute(
            history.update()
            .where(history.c.category == slug)
            .values(
                category_id=sa.select(history_category.c.id)
                .where(history_category.c.slug == slug)
                .scalar_subquery()
            )
        )

    op.drop_column("history", "category", schema=SCHEMA)


def downgrade():
    op.add_column("history", sa.Column("category", sa.String(20), nullable=True), schema=SCHEMA)

    conn = op.get_bind()
    conn.execute(
        history.update().values(
            category=sa.select(history_category.c.slug)
            .where(history_category.c.id == history.c.category_id)
            .scalar_subquery()
        )
    )

    op.drop_index(op.f("ix_nei_history_category_id"), table_name="history", schema=SCHEMA)
    op.drop_constraint(
        "fk_history_category_id_history_category", "history", schema=SCHEMA, type_="foreignkey"
    )
    op.drop_column("history", "category_id", schema=SCHEMA)

    op.drop_constraint(
        op.f("uq_history_category_slug"), "history_category", schema=SCHEMA, type_="unique"
    )
    op.drop_table("history_category", schema=SCHEMA)
