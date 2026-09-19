"""team_section belongs directly to team_mandate; drop team_category and team_member.mandate

Revision ID: a2c4e6f8b0d1
Revises: f9a1b3c5d7e9
Create Date: 2026-09-19

The team domain is simply:

    team_mandate -> team_section -> team_member

`team_category` sat between mandate and section but the public page flattened
it away immediately (`categories.flatMap(c => c.sections)`), so it carried no
meaning. `team_member.mandate` (b8f3a1c9e2d4) was a denormalized copy of
member -> section -> category -> mandate added only so the Directus CMS could
draw a flat O2M list; it could drift from `section_id`. Both go away here.
The domain must not bend to a CMS UI limitation.

Data handling (no loss of section name, section order, membership or mandate):
  1. add team_section.mandate and backfill it from the section's category;
  2. renumber section weights per mandate in the order the tree used to be
     rendered (category weight, category id, section weight, section id), so
     merging categories preserves the visible order;
  3. fail with a clear message if any section could not be assigned a mandate
     or any member lost its section, before constraints are tightened;
  4. drop team_section.category_id, team_category, team_member.mandate.

Downgrade reconstructs one category ("Direção", weight 0) per mandate and
re-derives team_member.mandate from the section. Original category *names*
beyond that single default (categories created later through the CMS) cannot
be reconstructed and are not restored.
"""

from alembic import op
import sqlalchemy as sa


revision = "a2c4e6f8b0d1"
down_revision = "f9a1b3c5d7e9"
branch_labels = None
depends_on = None

SCHEMA = "nei"


def upgrade() -> None:
    conn = op.get_bind()

    op.add_column(
        "team_section",
        sa.Column("mandate", sa.String(length=7), nullable=True),
        schema=SCHEMA,
    )
    conn.execute(
        sa.text(
            f"UPDATE {SCHEMA}.team_section s SET mandate = c.mandate"
            f" FROM {SCHEMA}.team_category c WHERE c.id = s.category_id"
        )
    )
    conn.execute(
        sa.text(
            f"""
            UPDATE {SCHEMA}.team_section s SET weight = r.rn
            FROM (
                SELECT s2.id,
                       ROW_NUMBER() OVER (
                           PARTITION BY c.mandate
                           ORDER BY c.weight, c.id, s2.weight, s2.id
                       ) - 1 AS rn
                FROM {SCHEMA}.team_section s2
                JOIN {SCHEMA}.team_category c ON c.id = s2.category_id
            ) r
            WHERE r.id = s.id
            """
        )
    )

    orphans = conn.execute(
        sa.text(f"SELECT id FROM {SCHEMA}.team_section WHERE mandate IS NULL")
    ).scalars().all()
    if orphans:
        raise RuntimeError(
            f"team_section rows without a resolvable mandate: {orphans}. "
            "Fix these rows (each must belong to a team_category) before migrating."
        )
    lost = conn.execute(
        sa.text(
            f"SELECT m.id FROM {SCHEMA}.team_member m"
            f" LEFT JOIN {SCHEMA}.team_section s ON s.id = m.section_id"
            " WHERE s.id IS NULL"
        )
    ).scalars().all()
    if lost:
        raise RuntimeError(f"team_member rows with no valid section: {lost}.")

    op.alter_column("team_section", "mandate", nullable=False, schema=SCHEMA)
    op.create_foreign_key(
        op.f("fk_team_section_mandate_team_mandate"),
        "team_section",
        "team_mandate",
        ["mandate"],
        ["mandate"],
        source_schema=SCHEMA,
        referent_schema=SCHEMA,
        ondelete="CASCADE",
    )
    op.create_index(
        op.f("ix_nei_team_section_mandate"), "team_section", ["mandate"], schema=SCHEMA
    )

    op.drop_index(
        op.f("ix_nei_team_section_category_id"), table_name="team_section", schema=SCHEMA
    )
    op.drop_constraint(
        op.f("fk_team_section_category_id_team_category"),
        "team_section",
        schema=SCHEMA,
        type_="foreignkey",
    )
    op.drop_column("team_section", "category_id", schema=SCHEMA)
    op.drop_index(
        op.f("ix_nei_team_category_mandate"), table_name="team_category", schema=SCHEMA
    )
    op.drop_table("team_category", schema=SCHEMA)

    op.drop_index(
        op.f("ix_nei_team_member_mandate"), table_name="team_member", schema=SCHEMA
    )
    op.drop_constraint(
        op.f("fk_team_member_mandate_team_mandate"),
        "team_member",
        schema=SCHEMA,
        type_="foreignkey",
    )
    op.drop_column("team_member", "mandate", schema=SCHEMA)


def downgrade() -> None:
    conn = op.get_bind()

    op.add_column(
        "team_member",
        sa.Column("mandate", sa.String(length=7), nullable=True),
        schema=SCHEMA,
    )
    op.create_table(
        "team_category",
        sa.Column("id", sa.Integer(), autoincrement=True, nullable=False),
        sa.Column("mandate", sa.String(length=7), nullable=False),
        sa.Column("name", sa.String(length=120), nullable=False),
        sa.Column("weight", sa.Integer(), nullable=False, server_default="0"),
        sa.ForeignKeyConstraint(
            ["mandate"],
            [f"{SCHEMA}.team_mandate.mandate"],
            name=op.f("fk_team_category_mandate_team_mandate"),
            ondelete="CASCADE",
        ),
        sa.PrimaryKeyConstraint("id", name=op.f("pk_team_category")),
        schema=SCHEMA,
    )
    op.create_index(
        op.f("ix_nei_team_category_mandate"), "team_category", ["mandate"], schema=SCHEMA
    )
    op.add_column(
        "team_section",
        sa.Column("category_id", sa.Integer(), nullable=True),
        schema=SCHEMA,
    )
    conn.execute(
        sa.text(
            f"INSERT INTO {SCHEMA}.team_category (mandate, name, weight)"
            f" SELECT mandate, 'Direção', 0 FROM {SCHEMA}.team_mandate"
        )
    )
    conn.execute(
        sa.text(
            f"UPDATE {SCHEMA}.team_section s SET category_id = c.id"
            f" FROM {SCHEMA}.team_category c WHERE c.mandate = s.mandate"
        )
    )
    conn.execute(
        sa.text(
            f"UPDATE {SCHEMA}.team_member m SET mandate = s.mandate"
            f" FROM {SCHEMA}.team_section s WHERE s.id = m.section_id"
        )
    )
    op.alter_column("team_section", "category_id", nullable=False, schema=SCHEMA)
    op.create_foreign_key(
        op.f("fk_team_section_category_id_team_category"),
        "team_section",
        "team_category",
        ["category_id"],
        ["id"],
        source_schema=SCHEMA,
        referent_schema=SCHEMA,
        ondelete="CASCADE",
    )
    op.create_index(
        op.f("ix_nei_team_section_category_id"),
        "team_section",
        ["category_id"],
        schema=SCHEMA,
    )
    op.create_foreign_key(
        op.f("fk_team_member_mandate_team_mandate"),
        "team_member",
        "team_mandate",
        ["mandate"],
        ["mandate"],
        source_schema=SCHEMA,
        referent_schema=SCHEMA,
        ondelete="CASCADE",
    )
    op.create_index(
        op.f("ix_nei_team_member_mandate"), "team_member", ["mandate"], schema=SCHEMA
    )

    op.drop_index(
        op.f("ix_nei_team_section_mandate"), table_name="team_section", schema=SCHEMA
    )
    op.drop_constraint(
        op.f("fk_team_section_mandate_team_mandate"),
        "team_section",
        schema=SCHEMA,
        type_="foreignkey",
    )
    op.drop_column("team_section", "mandate", schema=SCHEMA)
