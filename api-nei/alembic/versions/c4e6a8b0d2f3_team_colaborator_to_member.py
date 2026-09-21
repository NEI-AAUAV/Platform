"""fold team_colaborator into team_member and drop it

Revision ID: c4e6a8b0d2f3
Revises: b3d5f7a9c1e2
Create Date: 2026-09-19

A "colaborador" is just another person on a mandate's team page, shown under
"Colaboradores". It needs no separate account-keyed table. Each collaborator
becomes a `team_member` (name from the linked user, role "Colaborador") in a
per-mandate section named "Colaboradores", ordered after the existing sections.

The migration asserts every collaborator was carried over before the table is
dropped. It does not depend on the surrogate `id` that the retired
b5c7d9e1f3a5 revision used to add.

Downgrade recreates team_colaborator with its original composite primary key
(user_id, mandate) and moves the "Colaboradores" members that still have a
user back into it; members of that section without a linked user have no
representation in the old table and are dropped with the section.
"""

from alembic import op
import sqlalchemy as sa


revision = "c4e6a8b0d2f3"
down_revision = "b3d5f7a9c1e2"
branch_labels = None
depends_on = None

SCHEMA = "nei"
SECTION_NAME = "Colaboradores"
ROLE_NAME = "Colaborador"


def upgrade() -> None:
    conn = op.get_bind()

    conn.execute(
        sa.text(
            f"INSERT INTO {SCHEMA}.team_mandate (mandate)"
            f" SELECT DISTINCT c.mandate FROM {SCHEMA}.team_colaborator c"
            f" WHERE c.mandate NOT IN (SELECT mandate FROM {SCHEMA}.team_mandate)"
        )
    )
    conn.execute(
        sa.text(
            f"""
            INSERT INTO {SCHEMA}.team_section (mandate, name, weight)
            SELECT m.mandate, :section,
                   COALESCE((SELECT MAX(s.weight) + 1 FROM {SCHEMA}.team_section s
                             WHERE s.mandate = m.mandate), 0)
            FROM (SELECT DISTINCT mandate FROM {SCHEMA}.team_colaborator) m
            WHERE NOT EXISTS (
                SELECT 1 FROM {SCHEMA}.team_section s
                WHERE s.mandate = m.mandate AND s.name = :section
            )
            """
        ),
        {"section": SECTION_NAME},
    )
    conn.execute(
        sa.text(
            f"""
            INSERT INTO {SCHEMA}.team_member (section_id, user_id, name, role, weight)
            SELECT s.id, c.user_id,
                   COALESCE(NULLIF(BTRIM(CONCAT_WS(' ', u.name, u.surname)), ''), :role),
                   :role,
                   ROW_NUMBER() OVER (
                       PARTITION BY c.mandate
                       ORDER BY u.name, u.surname, c.user_id
                   ) - 1
            FROM {SCHEMA}.team_colaborator c
            JOIN {SCHEMA}."user" u ON u.id = c.user_id
            JOIN {SCHEMA}.team_section s
              ON s.mandate = c.mandate AND s.name = :section
            """
        ),
        {"section": SECTION_NAME, "role": ROLE_NAME},
    )

    missing = conn.execute(
        sa.text(
            f"""
            SELECT c.user_id, c.mandate FROM {SCHEMA}.team_colaborator c
            WHERE NOT EXISTS (
                SELECT 1 FROM {SCHEMA}.team_member m
                JOIN {SCHEMA}.team_section s ON s.id = m.section_id
                WHERE m.user_id = c.user_id AND s.mandate = c.mandate
                  AND s.name = :section
            )
            """
        ),
        {"section": SECTION_NAME},
    ).all()
    if missing:
        raise RuntimeError(f"team_colaborator rows not carried over: {missing}")

    op.drop_table("team_colaborator", schema=SCHEMA)


def downgrade() -> None:
    conn = op.get_bind()
    op.create_table(
        "team_colaborator",
        sa.Column("user_id", sa.Integer(), nullable=False),
        sa.Column("mandate", sa.String(length=7), nullable=False),
        sa.ForeignKeyConstraint(["user_id"], [f"{SCHEMA}.user.id"]),
        sa.PrimaryKeyConstraint("user_id", "mandate"),
        schema=SCHEMA,
    )
    conn.execute(
        sa.text(
            f"INSERT INTO {SCHEMA}.team_colaborator (user_id, mandate)"
            f" SELECT DISTINCT m.user_id, s.mandate FROM {SCHEMA}.team_member m"
            f" JOIN {SCHEMA}.team_section s ON s.id = m.section_id"
            " WHERE s.name = :section AND m.user_id IS NOT NULL"
        ),
        {"section": SECTION_NAME},
    )
    conn.execute(
        sa.text(
            f"DELETE FROM {SCHEMA}.team_member WHERE section_id IN"
            f" (SELECT id FROM {SCHEMA}.team_section WHERE name = :section)"
        ),
        {"section": SECTION_NAME},
    )
    conn.execute(
        sa.text(f"DELETE FROM {SCHEMA}.team_section WHERE name = :section"),
        {"section": SECTION_NAME},
    )
