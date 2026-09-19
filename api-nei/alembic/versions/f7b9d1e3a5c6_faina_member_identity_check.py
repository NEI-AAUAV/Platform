"""faina_member must have a linked user or a non-blank name

Revision ID: f7b9d1e3a5c6
Revises: e6a8c0d2f4b5
Create Date: 2026-09-19

Both `member_id` and `name` are optional (a commission member may be a
platform user, a plain name, or both), so a row with neither was possible and
displays as nobody. Not XOR: having both is valid, `name` being the editorial
display value and `member_id` optional enrichment.

As with the team, `name` becomes the editorial display identity: rows that
only have a linked user get their name copied from that user first, so every
existing member has a display name the CMS and the website can show.

Refuses to continue, listing the ids, if existing rows already violate this.
"""

from alembic import op
import sqlalchemy as sa


revision = "f7b9d1e3a5c6"
down_revision = "e6a8c0d2f4b5"
branch_labels = None
depends_on = None

SCHEMA = "nei"
CONDITION = "member_id IS NOT NULL OR NULLIF(BTRIM(name), '') IS NOT NULL"


def upgrade() -> None:
    conn = op.get_bind()
    conn.execute(
        sa.text(
            f"""
            UPDATE {SCHEMA}.faina_member m
            SET name = NULLIF(BTRIM(CONCAT_WS(' ', u.name, u.surname)), '')
            FROM {SCHEMA}."user" u
            WHERE m.member_id = u.id AND NULLIF(BTRIM(m.name), '') IS NULL
            """
        )
    )
    bad = conn.execute(
        sa.text(
            f"SELECT id FROM {SCHEMA}.faina_member WHERE NOT ({CONDITION})"
        )
    ).scalars().all()
    if bad:
        raise RuntimeError(
            f"faina_member rows with neither a user nor a name: {bad}. "
            "Set a name or link a user before migrating."
        )
    op.create_check_constraint(
        op.f("ck_faina_member_identity_required"),
        "faina_member",
        CONDITION,
        schema=SCHEMA,
    )


def downgrade() -> None:
    op.drop_constraint(
        op.f("ck_faina_member_identity_required"),
        "faina_member",
        schema=SCHEMA,
        type_="check",
    )
