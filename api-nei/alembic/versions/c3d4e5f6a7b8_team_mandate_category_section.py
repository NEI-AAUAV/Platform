"""Restructure the team into mandate -> category -> section -> member

Revision ID: c3d4e5f6a7b8
Revises: b2c3d4e5f6a7
Create Date: 2026-09-09 00:00:00.000000

The public page used to derive sections from `team_role.weight` with hard
coded slices. This migration turns that implicit grouping into real rows.

The data move mirrors the previous frontend rule: for each mandate the
members are ordered by role weight, the three lowest form "Mesa da RGM",
those with weight 4 form "Vogais", and the rest form "Coordenação". Check
the result against real data before running this in production.

The member photo (`team_member.header`) is kept.

"""

from alembic import op
import sqlalchemy as sa


revision = "c3d4e5f6a7b8"
down_revision = "d0c2e4f6a8b1"
branch_labels = None
depends_on = None

SCHEMA = "nei"

VOGAL_WEIGHT = 4
MESA_SIZE = 3


def upgrade() -> None:
    op.create_table(
        "team_mandate",
        sa.Column("mandate", sa.String(length=7), nullable=False),
        sa.PrimaryKeyConstraint("mandate", name=op.f("pk_team_mandate")),
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
        op.f("ix_nei_team_category_mandate"),
        "team_category",
        ["mandate"],
        schema=SCHEMA,
    )
    op.create_table(
        "team_section",
        sa.Column("id", sa.Integer(), autoincrement=True, nullable=False),
        sa.Column("category_id", sa.Integer(), nullable=False),
        sa.Column("name", sa.String(length=120), nullable=False),
        sa.Column("weight", sa.Integer(), nullable=False, server_default="0"),
        sa.ForeignKeyConstraint(
            ["category_id"],
            [f"{SCHEMA}.team_category.id"],
            name=op.f("fk_team_section_category_id_team_category"),
            ondelete="CASCADE",
        ),
        sa.PrimaryKeyConstraint("id", name=op.f("pk_team_section")),
        schema=SCHEMA,
    )
    op.create_index(
        op.f("ix_nei_team_section_category_id"),
        "team_section",
        ["category_id"],
        schema=SCHEMA,
    )

    # New columns are nullable while the existing rows are migrated.
    op.add_column(
        "team_member", sa.Column("section_id", sa.Integer(), nullable=True), schema=SCHEMA
    )
    op.add_column(
        "team_member", sa.Column("name", sa.String(length=120), nullable=True), schema=SCHEMA
    )
    op.add_column(
        "team_member", sa.Column("role", sa.String(length=120), nullable=True), schema=SCHEMA
    )
    op.add_column(
        "team_member",
        sa.Column("weight", sa.Integer(), nullable=False, server_default="0"),
        schema=SCHEMA,
    )

    _migrate_members()

    op.alter_column("team_member", "section_id", nullable=False, schema=SCHEMA)
    op.alter_column("team_member", "role", nullable=False, schema=SCHEMA)
    op.create_foreign_key(
        op.f("fk_team_member_section_id_team_section"),
        "team_member",
        "team_section",
        ["section_id"],
        ["id"],
        source_schema=SCHEMA,
        referent_schema=SCHEMA,
        ondelete="CASCADE",
    )
    op.create_index(
        op.f("ix_nei_team_member_section_id"),
        "team_member",
        ["section_id"],
        schema=SCHEMA,
    )

    op.drop_index("ix_nei_team_member_mandate", table_name="team_member", schema=SCHEMA)
    op.drop_column("team_member", "mandate", schema=SCHEMA)
    op.drop_constraint(
        "fk_team_member_role_id_team_role", "team_member", schema=SCHEMA, type_="foreignkey"
    )
    op.drop_index("ix_nei_team_member_role_id", table_name="team_member", schema=SCHEMA)
    op.drop_column("team_member", "role_id", schema=SCHEMA)


def _migrate_members() -> None:
    """Rebuild the implicit weight-based grouping as mandate/category/section rows."""

    conn = op.get_bind()

    mandates = [
        row[0]
        for row in conn.execute(
            sa.text(f"SELECT DISTINCT mandate FROM {SCHEMA}.team_member")
        )
    ]

    for mandate in mandates:
        conn.execute(
            sa.text(f"INSERT INTO {SCHEMA}.team_mandate (mandate) VALUES (:mandate)"),
            {"mandate": mandate},
        )
        category_id = conn.execute(
            sa.text(
                f"INSERT INTO {SCHEMA}.team_category (mandate, name, weight)"
                " VALUES (:mandate, 'Direção', 0) RETURNING id"
            ),
            {"mandate": mandate},
        ).scalar_one()

        members = conn.execute(
            sa.text(
                "SELECT m.id, r.name AS role_name, COALESCE(r.weight, 0) AS role_weight"
                f" FROM {SCHEMA}.team_member m"
                f" LEFT JOIN {SCHEMA}.team_role r ON r.id = m.role_id"
                " WHERE m.mandate = :mandate"
                " ORDER BY COALESCE(r.weight, 0) DESC, r.name ASC"
            ),
            {"mandate": mandate},
        ).all()

        # Same slicing the public page used: the three lowest weights are the
        # board, the `vogal_count` entries just above them are the "Vogais",
        # and everything before that is the coordination.
        vogal_count = sum(1 for m in members if m.role_weight == VOGAL_WEIGHT)
        cut = MESA_SIZE + vogal_count

        mesa = members[-MESA_SIZE:] if len(members) >= MESA_SIZE else members
        vogais = members[-cut:-MESA_SIZE] if len(members) > MESA_SIZE else []
        coordenacao = members[:-cut] if len(members) > cut else []

        sections = [
            ("Coordenação", 0, coordenacao),
            ("Vogais", 1, vogais),
            ("Mesa da RGM", 2, mesa),
        ]

        for name, weight, section_members in sections:
            if not section_members:
                continue

            section_id = conn.execute(
                sa.text(
                    f"INSERT INTO {SCHEMA}.team_section (category_id, name, weight)"
                    " VALUES (:category_id, :name, :weight) RETURNING id"
                ),
                {"category_id": category_id, "name": name, "weight": weight},
            ).scalar_one()

            for position, member in enumerate(section_members):
                conn.execute(
                    sa.text(
                        f"UPDATE {SCHEMA}.team_member"
                        " SET section_id = :section_id, role = :role, weight = :weight"
                        " WHERE id = :id"
                    ),
                    {
                        "section_id": section_id,
                        "role": member.role_name or "Membro",
                        "weight": position,
                        "id": member.id,
                    },
                )


def downgrade() -> None:
    op.add_column(
        "team_member", sa.Column("mandate", sa.String(length=7), nullable=True), schema=SCHEMA
    )
    op.add_column(
        "team_member", sa.Column("role_id", sa.Integer(), nullable=True), schema=SCHEMA
    )

    conn = op.get_bind()

    # Restore the mandate from the section's category.
    conn.execute(
        sa.text(
            f"UPDATE {SCHEMA}.team_member m SET mandate = c.mandate"
            f" FROM {SCHEMA}.team_section s"
            f" JOIN {SCHEMA}.team_category c ON c.id = s.category_id"
            " WHERE s.id = m.section_id"
        )
    )
    # Match each member back to a role by name, creating one when it is gone.
    conn.execute(
        sa.text(
            f"INSERT INTO {SCHEMA}.team_role (name, weight)"
            f" SELECT DISTINCT m.role, 0 FROM {SCHEMA}.team_member m"
            f" WHERE m.role NOT IN (SELECT name FROM {SCHEMA}.team_role)"
        )
    )
    conn.execute(
        sa.text(
            f"UPDATE {SCHEMA}.team_member m SET role_id = r.id"
            f" FROM {SCHEMA}.team_role r WHERE r.name = m.role"
        )
    )

    op.alter_column("team_member", "mandate", nullable=False, schema=SCHEMA)
    op.alter_column("team_member", "role_id", nullable=False, schema=SCHEMA)
    op.create_index(
        op.f("ix_nei_team_member_mandate"), "team_member", ["mandate"], schema=SCHEMA
    )
    op.create_index(
        op.f("ix_nei_team_member_role_id"), "team_member", ["role_id"], schema=SCHEMA
    )
    op.create_foreign_key(
        "fk_team_member_role_id_team_role",
        "team_member",
        "team_role",
        ["role_id"],
        ["id"],
        source_schema=SCHEMA,
        referent_schema=SCHEMA,
    )

    op.drop_index(op.f("ix_nei_team_member_section_id"), table_name="team_member", schema=SCHEMA)
    op.drop_constraint(
        op.f("fk_team_member_section_id_team_section"),
        "team_member",
        schema=SCHEMA,
        type_="foreignkey",
    )
    op.drop_column("team_member", "section_id", schema=SCHEMA)
    op.drop_column("team_member", "role", schema=SCHEMA)
    op.drop_column("team_member", "name", schema=SCHEMA)
    op.drop_column("team_member", "weight", schema=SCHEMA)

    op.drop_index(op.f("ix_nei_team_section_category_id"), table_name="team_section", schema=SCHEMA)
    op.drop_table("team_section", schema=SCHEMA)
    op.drop_index(op.f("ix_nei_team_category_mandate"), table_name="team_category", schema=SCHEMA)
    op.drop_table("team_category", schema=SCHEMA)
    op.drop_table("team_mandate", schema=SCHEMA)
