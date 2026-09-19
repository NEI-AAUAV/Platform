"""note_author: notes can be credited to someone without a Platform account

Revision ID: b4d6f8a0c2e5
Revises: a3c5e7b9d1f4
Create Date: 2026-09-19

Additive. `note.author_id` (a Platform account) keeps working; a note may
instead point at a `note_author` row created in the CMS.
"""
import sqlalchemy as sa
from alembic import op

from app.core.config import settings

revision = "b4d6f8a0c2e5"
down_revision = "a3c5e7b9d1f4"
branch_labels = None
depends_on = None

S = settings.SCHEMA_NAME


def upgrade():
    op.create_table(
        "note_author",
        sa.Column("id", sa.Integer(), autoincrement=True, nullable=False),
        sa.Column("name", sa.String(length=50), nullable=False),
        sa.Column("surname", sa.String(length=50), nullable=False),
        sa.PrimaryKeyConstraint("id", name=op.f("pk_note_author")),
        schema=S,
    )
    op.add_column(
        "note", sa.Column("note_author_id", sa.Integer(), nullable=True), schema=S
    )
    op.create_index(
        op.f("ix_note_note_author_id"), "note", ["note_author_id"], schema=S
    )
    op.create_foreign_key(
        "fk_note_author_id",
        "note",
        "note_author",
        ["note_author_id"],
        ["id"],
        source_schema=S,
        referent_schema=S,
        ondelete="SET NULL",
    )


def downgrade():
    op.drop_constraint("fk_note_author_id", "note", schema=S, type_="foreignkey")
    op.drop_index(op.f("ix_note_note_author_id"), table_name="note", schema=S)
    op.drop_column("note", "note_author_id", schema=S)
    op.drop_table("note_author", schema=S)
