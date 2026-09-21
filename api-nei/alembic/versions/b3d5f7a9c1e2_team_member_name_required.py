"""team_member.name is the canonical display identity: backfill and make it NOT NULL

Revision ID: b3d5f7a9c1e2
Revises: a2c4e6f8b0d1
Create Date: 2026-09-19

c3d4e5f6a7b8 added `team_member.name` as nullable and never filled it for
existing rows, while the API schemas already require `name: str`. Members
created before that change (identified only by `user_id`) therefore had
NULL names and would break serialization.

The editorial identity of a team member is now `name` alone, independent of
any platform account. This revision derives a name from the linked user for
every blank row, refuses to continue if any row still has no usable name, and
then enforces NOT NULL plus a non-blank CHECK.
"""

from alembic import op
import sqlalchemy as sa


revision = "b3d5f7a9c1e2"
down_revision = "a2c4e6f8b0d1"
branch_labels = None
depends_on = None

SCHEMA = "nei"


def upgrade() -> None:
    conn = op.get_bind()
    conn.execute(
        sa.text(
            f"""
            UPDATE {SCHEMA}.team_member m
            SET name = NULLIF(BTRIM(CONCAT_WS(' ', u.name, u.surname)), '')
            FROM {SCHEMA}."user" u
            WHERE m.user_id = u.id
              AND NULLIF(BTRIM(m.name), '') IS NULL
            """
        )
    )
    conn.execute(
        sa.text(
            f"UPDATE {SCHEMA}.team_member SET name = BTRIM(name)"
            " WHERE name IS NOT NULL AND name <> BTRIM(name)"
        )
    )
    blank = conn.execute(
        sa.text(
            f"SELECT id FROM {SCHEMA}.team_member WHERE NULLIF(BTRIM(name), '') IS NULL"
        )
    ).scalars().all()
    if blank:
        raise RuntimeError(
            f"team_member rows with no name and no linked user to derive one from: "
            f"{blank}. Give them a name before migrating."
        )

    op.alter_column(
        "team_member",
        "name",
        existing_type=sa.String(length=120),
        nullable=False,
        schema=SCHEMA,
    )
    op.create_check_constraint(
        op.f("ck_team_member_name_not_blank"),
        "team_member",
        "NULLIF(BTRIM(name), '') IS NOT NULL",
        schema=SCHEMA,
    )


def downgrade() -> None:
    op.drop_constraint(
        op.f("ck_team_member_name_not_blank"),
        "team_member",
        schema=SCHEMA,
        type_="check",
    )
    op.alter_column(
        "team_member",
        "name",
        existing_type=sa.String(length=120),
        nullable=True,
        schema=SCHEMA,
    )
