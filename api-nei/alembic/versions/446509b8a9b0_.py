"""Add events

Revision ID: 446509b8a9b0
Revises: f766070f7e9e
Create Date: 2023-10-28 01:27:42.668108

"""
from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import postgresql as pg

from app.core.config import settings

# revision identifiers, used by Alembic.
revision = "446509b8a9b0"
down_revision = "f766070f7e9e"
branch_labels = None
depends_on = None


def upgrade() -> None:
    op.alter_column(
        table_name="user",
        column_name="scopes",
        type_=pg.ARRAY(sa.Text),
        schema=settings.SCHEMA_NAME,
        postgresql_using="lower(scopes::text)::text[]",
    )
    scopes_enum = pg.ENUM(
        name="scope_enum",
        schema=settings.SCHEMA_NAME,
        inherit_schema=True,
        create_type=False,
    )
    scopes_enum.drop(op.get_bind(), checkfirst=False)
    op.execute(
        f"ALTER TABLE {settings.SCHEMA_NAME}.user RENAME CONSTRAINT user_iupi_key TO uq_user_iupi;"
    )
    op.execute(
        f"ALTER TABLE {settings.SCHEMA_NAME}.user RENAME CONSTRAINT user_nmec_key TO uq_user_nmec;"
    )
    op.create_table(
        "event",
        sa.Column("id", sa.Integer(), autoincrement=True, nullable=False),
        sa.Column("name", sa.String(), nullable=False),
        sa.Column("start", sa.DateTime(), nullable=False),
        sa.Column("end", sa.DateTime(), nullable=False),
        sa.PrimaryKeyConstraint("id", name=op.f("pk_event")),
        schema=settings.SCHEMA_NAME,
    )
    op.add_column(
        "user",
        sa.Column("for_event", sa.Integer(), nullable=True),
        schema=settings.SCHEMA_NAME,
    )
    op.create_foreign_key(
        op.f("fk_user_for_event_event"),
        "user",
        "event",
        ["for_event"],
        ["id"],
        source_schema=settings.SCHEMA_NAME,
        referent_schema=settings.SCHEMA_NAME,
    )


def downgrade() -> None:
    op.drop_constraint(
        op.f("fk_user_for_event_event"),
        "user",
        schema=settings.SCHEMA_NAME,
        type_="foreignkey",
    )
    op.drop_column("user", "for_event", schema=settings.SCHEMA_NAME)
    op.drop_table("event", schema=settings.SCHEMA_NAME)
    op.execute(
        f"ALTER TABLE {settings.SCHEMA_NAME}.user RENAME CONSTRAINT uq_user_nmec TO user_nmec_key;"
    )
    op.execute(
        f"ALTER TABLE {settings.SCHEMA_NAME}.user RENAME CONSTRAINT uq_user_iupi TO user_iupi_key;"
    )
    scopes_enum = pg.ENUM(
        "ADMIN",
        "MANAGER_NEI",
        "MANAGER_TACAUA",
        "MANAGER_FAMILY",
        "MANAGER_JANTAR_GALA",
        "DEFAULT",
        name="scope_enum",
        schema=settings.SCHEMA_NAME,
        inherit_schema=True,
        create_type=False,
    )
    scopes_enum.create(op.get_bind(), checkfirst=True)
    op.alter_column(
        table_name="user",
        column_name="scopes",
        type_=pg.ARRAY(scopes_enum),
        schema=settings.SCHEMA_NAME,
        postgresql_using=f"upper(scopes::text)::text[]::{settings.SCHEMA_NAME}.scope_enum[]",
    )
