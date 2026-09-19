"""team_mandate gets a generated integer id; team_section references it by mandate_id

Revision ID: c2e4a6b8d0f1
Revises: b9d1f3a5c7e8
Create Date: 2026-09-19

`team_mandate.mandate` ("2026/27") used to be the primary key and
`team_section.mandate` the foreign key. Both are editorial text, which forced
CMS editors to type and keep in sync a value that is really just a technical
link. The link becomes an integer:

    team_mandate.id   (generated, primary key)
    team_mandate.mandate  UNIQUE NOT NULL, format AAAA/AA, still the public identity
    team_section.mandate_id -> team_mandate.id  ON DELETE CASCADE

The public API keeps addressing mandates by string; the id is internal.

Order matters because the section FK depends on the old primary key:
  1. add + backfill team_mandate.id (sequence owned by the column);
  2. add + backfill team_section.mandate_id, fail loudly on any orphan;
  3. drop the old section FK/index/column (frees the old primary key);
  4. swap the primary key to id, keep mandate unique;
  5. add the new section FK and index.

Existing rows keep their sections and members. Rows whose mandate text is not
of the form AAAA/AA abort the migration before anything is tightened.

Downgrade restores the string key and rebuilds team_section.mandate from the
joined mandate row.
"""

from alembic import op
import sqlalchemy as sa


revision = "c2e4a6b8d0f1"
down_revision = "b9d1f3a5c7e8"
branch_labels = None
depends_on = None

S = "nei"
FORMAT = "mandate ~ '^[0-9]{4}/[0-9]{2}$'"


def upgrade() -> None:
    conn = op.get_bind()

    bad = conn.execute(
        sa.text(f"SELECT mandate FROM {S}.team_mandate WHERE NOT ({FORMAT})")
    ).scalars().all()
    if bad:
        raise RuntimeError(
            f"team_mandate rows whose mandate is not of the form AAAA/AA: {bad}. "
            "Fix them before migrating."
        )

    # 1. team_mandate.id
    op.add_column("team_mandate", sa.Column("id", sa.Integer(), nullable=True), schema=S)
    op.execute(f"CREATE SEQUENCE {S}.team_mandate_id_seq OWNED BY {S}.team_mandate.id")
    conn.execute(
        sa.text(
            f"""
            UPDATE {S}.team_mandate m SET id = r.rn
            FROM (
                SELECT mandate, ROW_NUMBER() OVER (ORDER BY mandate) AS rn
                FROM {S}.team_mandate
            ) r
            WHERE r.mandate = m.mandate
            """
        )
    )
    op.execute(
        f"SELECT setval('{S}.team_mandate_id_seq',"
        f" COALESCE((SELECT MAX(id) FROM {S}.team_mandate), 0) + 1, false)"
    )
    op.execute(
        f"ALTER TABLE {S}.team_mandate ALTER COLUMN id"
        f" SET DEFAULT nextval('{S}.team_mandate_id_seq')"
    )
    op.alter_column("team_mandate", "id", nullable=False, schema=S)

    # 2. team_section.mandate_id
    op.add_column(
        "team_section", sa.Column("mandate_id", sa.Integer(), nullable=True), schema=S
    )
    conn.execute(
        sa.text(
            f"UPDATE {S}.team_section s SET mandate_id = m.id"
            f" FROM {S}.team_mandate m WHERE m.mandate = s.mandate"
        )
    )
    orphans = conn.execute(
        sa.text(f"SELECT id FROM {S}.team_section WHERE mandate_id IS NULL")
    ).scalars().all()
    if orphans:
        raise RuntimeError(
            f"team_section rows without a valid mandate: {orphans}. "
            "Fix these rows before migrating."
        )
    op.alter_column("team_section", "mandate_id", nullable=False, schema=S)

    # 3. drop the old link (it depends on the old primary key)
    op.drop_index(op.f("ix_nei_team_section_mandate"), table_name="team_section", schema=S)
    op.drop_constraint(
        op.f("fk_team_section_mandate_team_mandate"),
        "team_section",
        schema=S,
        type_="foreignkey",
    )
    op.drop_column("team_section", "mandate", schema=S)

    # 4. primary key: mandate -> id
    op.drop_constraint(op.f("pk_team_mandate"), "team_mandate", schema=S, type_="primary")
    op.create_primary_key(op.f("pk_team_mandate"), "team_mandate", ["id"], schema=S)
    op.create_index(
        op.f("ix_nei_team_mandate_mandate"),
        "team_mandate",
        ["mandate"],
        unique=True,
        schema=S,
    )
    op.create_check_constraint(
        op.f("ck_team_mandate_mandate_format"), "team_mandate", FORMAT, schema=S
    )

    # 5. new link
    op.create_foreign_key(
        op.f("fk_team_section_mandate_id_team_mandate"),
        "team_section",
        "team_mandate",
        ["mandate_id"],
        ["id"],
        source_schema=S,
        referent_schema=S,
        ondelete="CASCADE",
    )
    op.create_index(
        op.f("ix_nei_team_section_mandate_id"), "team_section", ["mandate_id"], schema=S
    )


def downgrade() -> None:
    conn = op.get_bind()

    op.add_column(
        "team_section",
        sa.Column("mandate", sa.String(length=7), nullable=True),
        schema=S,
    )
    conn.execute(
        sa.text(
            f"UPDATE {S}.team_section s SET mandate = m.mandate"
            f" FROM {S}.team_mandate m WHERE m.id = s.mandate_id"
        )
    )
    op.alter_column("team_section", "mandate", nullable=False, schema=S)

    op.drop_index(op.f("ix_nei_team_section_mandate_id"), table_name="team_section", schema=S)
    op.drop_constraint(
        op.f("fk_team_section_mandate_id_team_mandate"),
        "team_section",
        schema=S,
        type_="foreignkey",
    )
    op.drop_column("team_section", "mandate_id", schema=S)

    op.drop_constraint(
        op.f("ck_team_mandate_mandate_format"), "team_mandate", schema=S, type_="check"
    )
    op.drop_index(op.f("ix_nei_team_mandate_mandate"), table_name="team_mandate", schema=S)
    op.drop_constraint(op.f("pk_team_mandate"), "team_mandate", schema=S, type_="primary")
    op.create_primary_key(op.f("pk_team_mandate"), "team_mandate", ["mandate"], schema=S)
    op.drop_column("team_mandate", "id", schema=S)  # also drops its owned sequence

    op.create_foreign_key(
        op.f("fk_team_section_mandate_team_mandate"),
        "team_section",
        "team_mandate",
        ["mandate"],
        ["mandate"],
        source_schema=S,
        referent_schema=S,
        ondelete="CASCADE",
    )
    op.create_index(
        op.f("ix_nei_team_section_mandate"), "team_section", ["mandate"], schema=S
    )
