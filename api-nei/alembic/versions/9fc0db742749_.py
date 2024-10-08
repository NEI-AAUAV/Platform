"""Make fields non-nullable

Revision ID: 9fc0db742749
Revises: 446509b8a9b0
Create Date: 2024-01-26 23:02:17.401693

"""

from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import postgresql

# revision identifiers, used by Alembic.
revision = "9fc0db742749"
down_revision = "446509b8a9b0"
branch_labels = None
depends_on = None


def upgrade() -> None:
    # ### commands auto generated by Alembic - please adjust! ###
    op.alter_column(
        "course", "public", existing_type=sa.BOOLEAN(), nullable=False, schema="nei"
    )
    op.alter_column(
        "faina",
        "mandate",
        existing_type=sa.VARCHAR(length=7),
        nullable=False,
        schema="nei",
    )
    op.alter_column(
        "faina_member",
        "faina_id",
        existing_type=sa.INTEGER(),
        nullable=False,
        schema="nei",
    )
    op.alter_column(
        "faina_member",
        "role_id",
        existing_type=sa.INTEGER(),
        nullable=False,
        schema="nei",
    )
    op.alter_column(
        "faina_role",
        "name",
        existing_type=sa.VARCHAR(length=20),
        nullable=False,
        schema="nei",
    )
    op.alter_column(
        "faina_role", "weight", existing_type=sa.INTEGER(), nullable=False, schema="nei"
    )
    op.alter_column(
        "history",
        "title",
        existing_type=sa.VARCHAR(length=120),
        nullable=False,
        schema="nei",
    )
    op.alter_column(
        "merch",
        "name",
        existing_type=sa.VARCHAR(length=256),
        nullable=False,
        schema="nei",
    )
    op.alter_column(
        "merch",
        "discontinued",
        existing_type=sa.BOOLEAN(),
        nullable=False,
        schema="nei",
    )
    op.alter_column(
        "news", "author_id", existing_type=sa.INTEGER(), nullable=False, schema="nei"
    )
    op.alter_column(
        "news", "public", existing_type=sa.BOOLEAN(), nullable=False, schema="nei"
    )
    op.alter_column(
        "news",
        "category",
        existing_type=postgresql.ENUM(
            "EVENT", "NEWS", "PARCERIA", name="category_enum", schema="nei"
        ),
        nullable=False,
        schema="nei",
    )
    op.alter_column(
        "news",
        "title",
        existing_type=sa.VARCHAR(length=256),
        nullable=False,
        schema="nei",
    )
    op.alter_column(
        "news",
        "created_at",
        existing_type=postgresql.TIMESTAMP(),
        nullable=False,
        schema="nei",
    )
    op.alter_column(
        "news",
        "updated_at",
        existing_type=postgresql.TIMESTAMP(),
        nullable=False,
        schema="nei",
    )
    op.alter_column(
        "note",
        "name",
        existing_type=sa.VARCHAR(length=256),
        nullable=False,
        schema="nei",
    )
    op.alter_column(
        "note",
        "location",
        existing_type=sa.VARCHAR(length=2048),
        nullable=False,
        schema="nei",
    )
    op.alter_column(
        "note", "summary", existing_type=sa.SMALLINT(), nullable=False, schema="nei"
    )
    op.alter_column(
        "note", "tests", existing_type=sa.SMALLINT(), nullable=False, schema="nei"
    )
    op.alter_column(
        "note",
        "bibliography",
        existing_type=sa.SMALLINT(),
        nullable=False,
        schema="nei",
    )
    op.alter_column(
        "note", "slides", existing_type=sa.SMALLINT(), nullable=False, schema="nei"
    )
    op.alter_column(
        "note", "exercises", existing_type=sa.SMALLINT(), nullable=False, schema="nei"
    )
    op.alter_column(
        "note", "projects", existing_type=sa.SMALLINT(), nullable=False, schema="nei"
    )
    op.alter_column(
        "note", "notebook", existing_type=sa.SMALLINT(), nullable=False, schema="nei"
    )
    op.alter_column(
        "note",
        "created_at",
        existing_type=postgresql.TIMESTAMP(),
        nullable=False,
        schema="nei",
    )
    op.alter_column(
        "partner",
        "company",
        existing_type=sa.VARCHAR(length=256),
        nullable=False,
        schema="nei",
    )
    op.alter_column(
        "redirect",
        "alias",
        existing_type=sa.VARCHAR(length=256),
        nullable=False,
        schema="nei",
    )
    op.alter_column(
        "redirect",
        "redirect",
        existing_type=sa.VARCHAR(length=2048),
        nullable=False,
        schema="nei",
    )
    op.alter_column(
        "rgm",
        "category",
        existing_type=sa.VARCHAR(length=3),
        nullable=False,
        schema="nei",
    )
    op.alter_column(
        "rgm",
        "date",
        existing_type=postgresql.TIMESTAMP(),
        nullable=False,
        schema="nei",
    )
    op.alter_column(
        "rgm",
        "title",
        existing_type=sa.VARCHAR(length=264),
        nullable=False,
        schema="nei",
    )
    op.alter_column(
        "rgm",
        "file",
        existing_type=sa.VARCHAR(length=2048),
        nullable=False,
        schema="nei",
    )
    op.alter_column(
        "senior", "year", existing_type=sa.INTEGER(), nullable=False, schema="nei"
    )
    op.alter_column(
        "senior",
        "course",
        existing_type=sa.VARCHAR(length=6),
        nullable=False,
        schema="nei",
    )
    op.alter_column(
        "subject", "public", existing_type=sa.BOOLEAN(), nullable=False, schema="nei"
    )
    op.alter_column(
        "subject",
        "short",
        existing_type=sa.VARCHAR(length=8),
        nullable=False,
        schema="nei",
    )
    op.alter_column(
        "teacher",
        "name",
        existing_type=sa.VARCHAR(length=100),
        nullable=False,
        schema="nei",
    )
    op.alter_column(
        "team_member",
        "mandate",
        existing_type=sa.VARCHAR(length=7),
        nullable=False,
        schema="nei",
    )
    op.alter_column(
        "team_member",
        "role_id",
        existing_type=sa.INTEGER(),
        nullable=False,
        schema="nei",
    )
    op.alter_column(
        "team_role",
        "name",
        existing_type=sa.VARCHAR(length=120),
        nullable=False,
        schema="nei",
    )
    op.alter_column(
        "team_role", "weight", existing_type=sa.INTEGER(), nullable=False, schema="nei"
    )
    op.alter_column(
        "user",
        "scopes",
        existing_type=postgresql.ARRAY(sa.TEXT()),
        nullable=False,
        schema="nei",
    )
    op.alter_column(
        "video",
        "title",
        existing_type=sa.VARCHAR(length=256),
        nullable=False,
        schema="nei",
    )
    op.alter_column(
        "video",
        "created_at",
        existing_type=postgresql.TIMESTAMP(),
        nullable=False,
        schema="nei",
    )
    op.alter_column(
        "video_tag",
        "name",
        existing_type=sa.VARCHAR(length=256),
        nullable=False,
        schema="nei",
    )
    op.alter_column(
        "video_tag",
        "color",
        existing_type=sa.VARCHAR(length=18),
        nullable=False,
        schema="nei",
    )
    # ### end Alembic commands ###


def downgrade() -> None:
    # ### commands auto generated by Alembic - please adjust! ###
    op.alter_column(
        "video_tag",
        "color",
        existing_type=sa.VARCHAR(length=18),
        nullable=True,
        schema="nei",
    )
    op.alter_column(
        "video_tag",
        "name",
        existing_type=sa.VARCHAR(length=256),
        nullable=True,
        schema="nei",
    )
    op.alter_column(
        "video",
        "created_at",
        existing_type=postgresql.TIMESTAMP(),
        nullable=True,
        schema="nei",
    )
    op.alter_column(
        "video",
        "title",
        existing_type=sa.VARCHAR(length=256),
        nullable=True,
        schema="nei",
    )
    op.alter_column(
        "user",
        "scopes",
        existing_type=postgresql.ARRAY(sa.TEXT()),
        nullable=True,
        schema="nei",
    )
    op.alter_column(
        "team_role", "weight", existing_type=sa.INTEGER(), nullable=True, schema="nei"
    )
    op.alter_column(
        "team_role",
        "name",
        existing_type=sa.VARCHAR(length=120),
        nullable=True,
        schema="nei",
    )
    op.alter_column(
        "team_member",
        "role_id",
        existing_type=sa.INTEGER(),
        nullable=True,
        schema="nei",
    )
    op.alter_column(
        "team_member",
        "mandate",
        existing_type=sa.VARCHAR(length=7),
        nullable=True,
        schema="nei",
    )
    op.alter_column(
        "teacher",
        "name",
        existing_type=sa.VARCHAR(length=100),
        nullable=True,
        schema="nei",
    )
    op.alter_column(
        "subject",
        "short",
        existing_type=sa.VARCHAR(length=8),
        nullable=True,
        schema="nei",
    )
    op.alter_column(
        "subject", "public", existing_type=sa.BOOLEAN(), nullable=True, schema="nei"
    )
    op.alter_column(
        "senior",
        "course",
        existing_type=sa.VARCHAR(length=6),
        nullable=True,
        schema="nei",
    )
    op.alter_column(
        "senior", "year", existing_type=sa.INTEGER(), nullable=True, schema="nei"
    )
    op.alter_column(
        "rgm",
        "file",
        existing_type=sa.VARCHAR(length=2048),
        nullable=True,
        schema="nei",
    )
    op.alter_column(
        "rgm",
        "title",
        existing_type=sa.VARCHAR(length=264),
        nullable=True,
        schema="nei",
    )
    op.alter_column(
        "rgm", "date", existing_type=postgresql.TIMESTAMP(), nullable=True, schema="nei"
    )
    op.alter_column(
        "rgm",
        "category",
        existing_type=sa.VARCHAR(length=3),
        nullable=True,
        schema="nei",
    )
    op.alter_column(
        "redirect",
        "redirect",
        existing_type=sa.VARCHAR(length=2048),
        nullable=True,
        schema="nei",
    )
    op.alter_column(
        "redirect",
        "alias",
        existing_type=sa.VARCHAR(length=256),
        nullable=True,
        schema="nei",
    )
    op.alter_column(
        "partner",
        "company",
        existing_type=sa.VARCHAR(length=256),
        nullable=True,
        schema="nei",
    )
    op.alter_column(
        "note",
        "created_at",
        existing_type=postgresql.TIMESTAMP(),
        nullable=True,
        schema="nei",
    )
    op.alter_column(
        "note", "notebook", existing_type=sa.SMALLINT(), nullable=True, schema="nei"
    )
    op.alter_column(
        "note", "projects", existing_type=sa.SMALLINT(), nullable=True, schema="nei"
    )
    op.alter_column(
        "note", "exercises", existing_type=sa.SMALLINT(), nullable=True, schema="nei"
    )
    op.alter_column(
        "note", "slides", existing_type=sa.SMALLINT(), nullable=True, schema="nei"
    )
    op.alter_column(
        "note", "bibliography", existing_type=sa.SMALLINT(), nullable=True, schema="nei"
    )
    op.alter_column(
        "note", "tests", existing_type=sa.SMALLINT(), nullable=True, schema="nei"
    )
    op.alter_column(
        "note", "summary", existing_type=sa.SMALLINT(), nullable=True, schema="nei"
    )
    op.alter_column(
        "note",
        "location",
        existing_type=sa.VARCHAR(length=2048),
        nullable=True,
        schema="nei",
    )
    op.alter_column(
        "note",
        "name",
        existing_type=sa.VARCHAR(length=256),
        nullable=True,
        schema="nei",
    )
    op.alter_column(
        "news",
        "updated_at",
        existing_type=postgresql.TIMESTAMP(),
        nullable=True,
        schema="nei",
    )
    op.alter_column(
        "news",
        "created_at",
        existing_type=postgresql.TIMESTAMP(),
        nullable=True,
        schema="nei",
    )
    op.alter_column(
        "news",
        "title",
        existing_type=sa.VARCHAR(length=256),
        nullable=True,
        schema="nei",
    )
    op.alter_column(
        "news",
        "category",
        existing_type=postgresql.ENUM(
            "EVENT", "NEWS", "PARCERIA", name="category_enum", schema="nei"
        ),
        nullable=True,
        schema="nei",
    )
    op.alter_column(
        "news", "public", existing_type=sa.BOOLEAN(), nullable=True, schema="nei"
    )
    op.alter_column(
        "news", "author_id", existing_type=sa.INTEGER(), nullable=True, schema="nei"
    )
    op.alter_column(
        "merch", "discontinued", existing_type=sa.BOOLEAN(), nullable=True, schema="nei"
    )
    op.alter_column(
        "merch",
        "name",
        existing_type=sa.VARCHAR(length=256),
        nullable=True,
        schema="nei",
    )
    op.alter_column(
        "history",
        "title",
        existing_type=sa.VARCHAR(length=120),
        nullable=True,
        schema="nei",
    )
    op.alter_column(
        "faina_role", "weight", existing_type=sa.INTEGER(), nullable=True, schema="nei"
    )
    op.alter_column(
        "faina_role",
        "name",
        existing_type=sa.VARCHAR(length=20),
        nullable=True,
        schema="nei",
    )
    op.alter_column(
        "faina_member",
        "role_id",
        existing_type=sa.INTEGER(),
        nullable=True,
        schema="nei",
    )
    op.alter_column(
        "faina_member",
        "faina_id",
        existing_type=sa.INTEGER(),
        nullable=True,
        schema="nei",
    )
    op.alter_column(
        "faina",
        "mandate",
        existing_type=sa.VARCHAR(length=7),
        nullable=True,
        schema="nei",
    )
    op.alter_column(
        "course", "public", existing_type=sa.BOOLEAN(), nullable=True, schema="nei"
    )
    # ### end Alembic commands ###
