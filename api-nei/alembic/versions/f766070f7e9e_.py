"""Initial revision

Revision ID: f766070f7e9e
Revises: 
Create Date: 2023-10-27 23:42:50.638147

"""
from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import postgresql

from app.core.config import settings

# revision identifiers, used by Alembic.
revision = "f766070f7e9e"
down_revision = None
branch_labels = None
depends_on = None


def upgrade() -> None:
    op.create_table(
        "course",
        sa.Column("code", sa.Integer(), autoincrement=False, nullable=False),
        sa.Column("public", sa.Boolean(), nullable=True),
        sa.Column("name", sa.String(length=128), nullable=False),
        sa.Column("short", sa.String(length=8), nullable=True),
        sa.PrimaryKeyConstraint("code"),
        schema=settings.SCHEMA_NAME,
    )
    op.create_table(
        "faina",
        sa.Column("id", sa.Integer(), autoincrement=True, nullable=False),
        sa.Column("image", sa.String(length=2048), nullable=True),
        sa.Column("mandate", sa.String(length=7), nullable=True),
        sa.PrimaryKeyConstraint("id"),
        schema=settings.SCHEMA_NAME,
    )
    op.create_table(
        "faina_role",
        sa.Column("id", sa.Integer(), autoincrement=True, nullable=False),
        sa.Column("name", sa.String(length=20), nullable=True),
        sa.Column("weight", sa.Integer(), nullable=True),
        sa.PrimaryKeyConstraint("id"),
        schema=settings.SCHEMA_NAME,
    )
    op.create_table(
        "history",
        sa.Column("moment", sa.Date(), nullable=False),
        sa.Column("title", sa.String(length=120), nullable=True),
        sa.Column("body", sa.Text(), nullable=True),
        sa.Column("image", sa.String(length=2048), nullable=True),
        sa.PrimaryKeyConstraint("moment"),
        schema=settings.SCHEMA_NAME,
    )
    op.create_table(
        "merch",
        sa.Column("id", sa.Integer(), autoincrement=True, nullable=False),
        sa.Column("name", sa.String(length=256), nullable=True),
        sa.Column("image", sa.String(length=2048), nullable=True),
        sa.Column("price", sa.Float(), nullable=True),
        sa.Column("number_of_items", sa.Integer(), nullable=True),
        sa.Column("discontinued", sa.Boolean(), nullable=True),
        sa.PrimaryKeyConstraint("id"),
        schema=settings.SCHEMA_NAME,
    )
    op.create_table(
        "partner",
        sa.Column("id", sa.Integer(), autoincrement=True, nullable=False),
        sa.Column("header", sa.String(length=2048), nullable=True),
        sa.Column("company", sa.String(length=256), nullable=True),
        sa.Column("description", sa.Text(), nullable=True),
        sa.Column("content", sa.String(length=256), nullable=True),
        sa.Column("link", sa.String(length=256), nullable=True),
        sa.Column("banner_url", sa.String(length=256), nullable=True),
        sa.Column("banner_image", sa.String(length=2048), nullable=True),
        sa.Column("banner_until", sa.DateTime(), nullable=True),
        sa.PrimaryKeyConstraint("id"),
        schema=settings.SCHEMA_NAME,
    )
    op.create_table(
        "redirect",
        sa.Column("id", sa.Integer(), autoincrement=True, nullable=False),
        sa.Column("alias", sa.String(length=256), nullable=True),
        sa.Column("redirect", sa.String(length=2048), nullable=True),
        sa.PrimaryKeyConstraint("id"),
        schema=settings.SCHEMA_NAME,
    )
    op.create_table(
        "rgm",
        sa.Column("id", sa.Integer(), autoincrement=True, nullable=False),
        sa.Column("category", sa.String(length=3), nullable=True),
        sa.Column("mandate", sa.String(length=7), nullable=False),
        sa.Column("date", sa.DateTime(), nullable=True),
        sa.Column("title", sa.String(length=264), nullable=True),
        sa.Column("file", sa.String(length=2048), nullable=True),
        sa.PrimaryKeyConstraint("id"),
        schema=settings.SCHEMA_NAME,
    )
    op.create_index(
        op.f("ix_nei_rgm_mandate"),
        "rgm",
        ["mandate"],
        unique=False,
        schema=settings.SCHEMA_NAME,
    )
    op.create_table(
        "senior",
        sa.Column("id", sa.Integer(), autoincrement=True, nullable=False),
        sa.Column("year", sa.Integer(), nullable=True),
        sa.Column("course", sa.String(length=6), nullable=True),
        sa.Column("image", sa.String(length=2048), nullable=True),
        sa.PrimaryKeyConstraint("id"),
        sa.UniqueConstraint("year", "course", name="uc_year_course"),
        schema=settings.SCHEMA_NAME,
    )
    op.create_table(
        "subject",
        sa.Column("code", sa.Integer(), autoincrement=False, nullable=False),
        sa.Column("public", sa.Boolean(), nullable=True),
        sa.Column("curricular_year", sa.Integer(), nullable=True),
        sa.Column("name", sa.String(length=128), nullable=False),
        sa.Column("short", sa.String(length=8), nullable=True),
        sa.Column("link", sa.String(length=2048), nullable=True),
        sa.PrimaryKeyConstraint("code"),
        schema=settings.SCHEMA_NAME,
    )
    op.create_table(
        "teacher",
        sa.Column("id", sa.Integer(), autoincrement=True, nullable=False),
        sa.Column("name", sa.String(length=100), nullable=True),
        sa.Column("personal_page", sa.String(length=256), nullable=True),
        sa.PrimaryKeyConstraint("id"),
        schema=settings.SCHEMA_NAME,
    )
    op.create_table(
        "team_role",
        sa.Column("id", sa.Integer(), autoincrement=True, nullable=False),
        sa.Column("name", sa.String(length=120), nullable=True),
        sa.Column("weight", sa.Integer(), nullable=True),
        sa.PrimaryKeyConstraint("id"),
        schema=settings.SCHEMA_NAME,
    )
    op.create_index(
        op.f("ix_nei_team_role_weight"),
        "team_role",
        ["weight"],
        unique=False,
        schema=settings.SCHEMA_NAME,
    )
    gender_enum = postgresql.ENUM(
        "MALE",
        "FEMALE",
        name="gender_enum",
        schema=settings.SCHEMA_NAME,
        inherit_schema=True,
        create_type=False,
    )
    gender_enum.create(op.get_bind(), checkfirst=True)
    scopes_enum = postgresql.ENUM(
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
    op.create_table(
        "user",
        sa.Column("id", sa.Integer(), autoincrement=True, nullable=False),
        sa.Column("iupi", sa.String(length=36), nullable=True),
        sa.Column("nmec", sa.Integer(), nullable=True),
        sa.Column("hashed_password", sa.Text(), nullable=True),
        sa.Column("name", sa.String(length=20), nullable=False),
        sa.Column("surname", sa.String(length=20), nullable=False),
        sa.Column(
            "gender",
            gender_enum,
            nullable=True,
        ),
        sa.Column("image", sa.String(length=2048), nullable=True),
        sa.Column("curriculum", sa.String(length=2048), nullable=True),
        sa.Column("linkedin", sa.String(length=2048), nullable=True),
        sa.Column("github", sa.String(length=2048), nullable=True),
        sa.Column(
            "scopes",
            postgresql.ARRAY(scopes_enum),
            nullable=True,
        ),
        sa.Column("updated_at", sa.DateTime(), nullable=False),
        sa.Column("created_at", sa.DateTime(), nullable=False),
        sa.Column("birthday", sa.Date(), nullable=True),
        sa.PrimaryKeyConstraint("id"),
        sa.UniqueConstraint("iupi", name="user_iupi_key"),
        sa.UniqueConstraint("nmec", name="user_nmec_key"),
        schema=settings.SCHEMA_NAME,
    )
    op.create_index(
        op.f("ix_nei_user_created_at"),
        "user",
        ["created_at"],
        unique=False,
        schema=settings.SCHEMA_NAME,
    )
    op.create_index(
        op.f("ix_nei_user_updated_at"),
        "user",
        ["updated_at"],
        unique=False,
        schema=settings.SCHEMA_NAME,
    )
    op.create_table(
        "video",
        sa.Column("id", sa.Integer(), autoincrement=True, nullable=False),
        sa.Column("youtube_id", sa.String(length=256), nullable=True),
        sa.Column("title", sa.String(length=256), nullable=True),
        sa.Column("subtitle", sa.String(length=256), nullable=True),
        sa.Column("image", sa.String(length=2048), nullable=True),
        sa.Column("created_at", sa.DateTime(), nullable=True),
        sa.Column("playlist", sa.SmallInteger(), nullable=True),
        sa.PrimaryKeyConstraint("id"),
        schema=settings.SCHEMA_NAME,
    )
    op.create_index(
        op.f("ix_nei_video_created_at"),
        "video",
        ["created_at"],
        unique=False,
        schema=settings.SCHEMA_NAME,
    )
    op.create_table(
        "video_tag",
        sa.Column("id", sa.Integer(), autoincrement=True, nullable=False),
        sa.Column("name", sa.String(length=256), nullable=True),
        sa.Column("color", sa.String(length=18), nullable=True),
        sa.PrimaryKeyConstraint("id"),
        schema=settings.SCHEMA_NAME,
    )
    op.create_table(
        "device_login",
        sa.Column("user_id", sa.Integer(), nullable=False),
        sa.Column("session_id", sa.Integer(), nullable=False),
        sa.Column("refreshed_at", sa.DateTime(), nullable=False),
        sa.Column("expires_at", sa.DateTime(), nullable=False),
        sa.ForeignKeyConstraint(["user_id"], ["nei.user.id"], ondelete="CASCADE"),
        sa.PrimaryKeyConstraint("user_id", "session_id"),
        schema=settings.SCHEMA_NAME,
    )
    op.create_table(
        "faina_member",
        sa.Column("id", sa.Integer(), autoincrement=True, nullable=False),
        sa.Column("member_id", sa.Integer(), nullable=True),
        sa.Column("faina_id", sa.Integer(), nullable=True),
        sa.Column("role_id", sa.Integer(), nullable=True),
        sa.ForeignKeyConstraint(
            ["faina_id"],
            ["nei.faina.id"],
        ),
        sa.ForeignKeyConstraint(
            ["member_id"],
            ["nei.user.id"],
        ),
        sa.ForeignKeyConstraint(
            ["role_id"],
            ["nei.faina_role.id"],
        ),
        sa.PrimaryKeyConstraint("id"),
        schema=settings.SCHEMA_NAME,
    )
    op.create_index(
        op.f("ix_nei_faina_member_faina_id"),
        "faina_member",
        ["faina_id"],
        unique=False,
        schema=settings.SCHEMA_NAME,
    )
    op.create_index(
        op.f("ix_nei_faina_member_member_id"),
        "faina_member",
        ["member_id"],
        unique=False,
        schema=settings.SCHEMA_NAME,
    )
    op.create_index(
        op.f("ix_nei_faina_member_role_id"),
        "faina_member",
        ["role_id"],
        unique=False,
        schema=settings.SCHEMA_NAME,
    )
    category_enum = postgresql.ENUM(
        "EVENT",
        "NEWS",
        "PARCERIA",
        name="category_enum",
        schema=settings.SCHEMA_NAME,
        inherit_schema=True,
        create_type=False,
    )
    category_enum.create(op.get_bind(), checkfirst=True)
    op.create_table(
        "news",
        sa.Column("id", sa.Integer(), autoincrement=True, nullable=False),
        sa.Column("author_id", sa.Integer(), nullable=True),
        sa.Column("public", sa.Boolean(), nullable=True),
        sa.Column(
            "category",
            category_enum,
            nullable=True,
        ),
        sa.Column("header", sa.String(length=2048), nullable=True),
        sa.Column("title", sa.String(length=256), nullable=True),
        sa.Column("content", sa.String(length=20000), nullable=True),
        sa.Column("created_at", sa.DateTime(), nullable=True),
        sa.Column("updated_at", sa.DateTime(), nullable=True),
        sa.ForeignKeyConstraint(["author_id"], ["nei.user.id"], name="fk_author_id"),
        sa.PrimaryKeyConstraint("id"),
        schema=settings.SCHEMA_NAME,
    )
    op.create_index(
        op.f("ix_nei_news_author_id"),
        "news",
        ["author_id"],
        unique=False,
        schema=settings.SCHEMA_NAME,
    )
    op.create_table(
        "note",
        sa.Column("id", sa.Integer(), autoincrement=True, nullable=False),
        sa.Column("author_id", sa.Integer(), nullable=True),
        sa.Column("subject_id", sa.Integer(), nullable=True),
        sa.Column("teacher_id", sa.Integer(), nullable=True),
        sa.Column("name", sa.String(length=256), nullable=True),
        sa.Column("location", sa.String(length=2048), nullable=True),
        sa.Column("year", sa.SmallInteger(), nullable=True),
        sa.Column("summary", sa.SmallInteger(), nullable=True),
        sa.Column("tests", sa.SmallInteger(), nullable=True),
        sa.Column("bibliography", sa.SmallInteger(), nullable=True),
        sa.Column("slides", sa.SmallInteger(), nullable=True),
        sa.Column("exercises", sa.SmallInteger(), nullable=True),
        sa.Column("projects", sa.SmallInteger(), nullable=True),
        sa.Column("notebook", sa.SmallInteger(), nullable=True),
        sa.Column("created_at", sa.DateTime(), nullable=True),
        sa.ForeignKeyConstraint(["author_id"], ["nei.user.id"], name="fk_author_id"),
        sa.ForeignKeyConstraint(
            ["subject_id"], ["nei.subject.code"], name="fk_subject_id"
        ),
        sa.ForeignKeyConstraint(
            ["teacher_id"], ["nei.teacher.id"], name="fk_teacher_id"
        ),
        sa.PrimaryKeyConstraint("id"),
        schema=settings.SCHEMA_NAME,
    )
    op.create_index(
        op.f("ix_nei_note_author_id"),
        "note",
        ["author_id"],
        unique=False,
        schema=settings.SCHEMA_NAME,
    )
    op.create_index(
        op.f("ix_nei_note_created_at"),
        "note",
        ["created_at"],
        unique=False,
        schema=settings.SCHEMA_NAME,
    )
    op.create_index(
        op.f("ix_nei_note_subject_id"),
        "note",
        ["subject_id"],
        unique=False,
        schema=settings.SCHEMA_NAME,
    )
    op.create_index(
        op.f("ix_nei_note_teacher_id"),
        "note",
        ["teacher_id"],
        unique=False,
        schema=settings.SCHEMA_NAME,
    )
    op.create_index(
        op.f("ix_nei_note_year"),
        "note",
        ["year"],
        unique=False,
        schema=settings.SCHEMA_NAME,
    )
    op.create_table(
        "senior_student",
        sa.Column("senior_id", sa.Integer(), nullable=False),
        sa.Column("user_id", sa.Integer(), nullable=False),
        sa.Column("quote", sa.String(length=280), nullable=True),
        sa.Column("image", sa.String(length=2048), nullable=True),
        sa.ForeignKeyConstraint(
            ["senior_id"],
            ["nei.senior.id"],
        ),
        sa.ForeignKeyConstraint(
            ["user_id"],
            ["nei.user.id"],
        ),
        sa.PrimaryKeyConstraint("senior_id", "user_id"),
        schema=settings.SCHEMA_NAME,
    )
    op.create_table(
        "team_colaborator",
        sa.Column("user_id", sa.Integer(), nullable=False),
        sa.Column("mandate", sa.String(length=7), nullable=False),
        sa.ForeignKeyConstraint(
            ["user_id"],
            ["nei.user.id"],
        ),
        sa.PrimaryKeyConstraint("user_id", "mandate"),
        schema=settings.SCHEMA_NAME,
    )
    op.create_table(
        "team_member",
        sa.Column("id", sa.Integer(), autoincrement=True, nullable=False),
        sa.Column("header", sa.String(length=2048), nullable=True),
        sa.Column("mandate", sa.String(length=7), nullable=True),
        sa.Column("user_id", sa.Integer(), nullable=True),
        sa.Column("role_id", sa.Integer(), nullable=True),
        sa.ForeignKeyConstraint(
            ["role_id"],
            ["nei.team_role.id"],
        ),
        sa.ForeignKeyConstraint(
            ["user_id"],
            ["nei.user.id"],
        ),
        sa.PrimaryKeyConstraint("id"),
        schema=settings.SCHEMA_NAME,
    )
    op.create_index(
        op.f("ix_nei_team_member_mandate"),
        "team_member",
        ["mandate"],
        unique=False,
        schema=settings.SCHEMA_NAME,
    )
    op.create_index(
        op.f("ix_nei_team_member_role_id"),
        "team_member",
        ["role_id"],
        unique=False,
        schema=settings.SCHEMA_NAME,
    )
    op.create_index(
        op.f("ix_nei_team_member_user_id"),
        "team_member",
        ["user_id"],
        unique=False,
        schema=settings.SCHEMA_NAME,
    )
    op.create_table(
        "user_email",
        sa.Column("user_id", sa.Integer(), nullable=False),
        sa.Column("active", sa.Boolean(), nullable=False),
        sa.Column("email", sa.Text(), nullable=False),
        sa.ForeignKeyConstraint(["user_id"], ["nei.user.id"], ondelete="CASCADE"),
        sa.PrimaryKeyConstraint("user_id", "email"),
        schema=settings.SCHEMA_NAME,
    )
    op.create_table(
        "user_matriculation",
        sa.Column("id", sa.Integer(), autoincrement=True, nullable=False),
        sa.Column("user_id", sa.Integer(), nullable=False),
        sa.Column("course_id", sa.Integer(), nullable=False),
        sa.Column("subject_ids", sa.ARRAY(sa.Integer()), nullable=False),
        sa.Column("curricular_year", sa.Integer(), nullable=False),
        sa.Column("created_at", sa.DateTime(), nullable=False),
        sa.ForeignKeyConstraint(
            ["course_id"],
            ["nei.course.code"],
        ),
        sa.ForeignKeyConstraint(
            ["user_id"],
            ["nei.user.id"],
        ),
        sa.PrimaryKeyConstraint("id"),
        schema=settings.SCHEMA_NAME,
    )
    op.create_index(
        op.f("ix_nei_user_matriculation_course_id"),
        "user_matriculation",
        ["course_id"],
        unique=False,
        schema=settings.SCHEMA_NAME,
    )
    op.create_index(
        op.f("ix_nei_user_matriculation_created_at"),
        "user_matriculation",
        ["created_at"],
        unique=False,
        schema=settings.SCHEMA_NAME,
    )
    op.create_index(
        op.f("ix_nei_user_matriculation_user_id"),
        "user_matriculation",
        ["user_id"],
        unique=False,
        schema=settings.SCHEMA_NAME,
    )
    op.create_table(
        "video__video_tags",
        sa.Column("video_id", sa.Integer(), nullable=False),
        sa.Column("video_tag_id", sa.Integer(), nullable=False),
        sa.ForeignKeyConstraint(
            ["video_id"],
            ["nei.video.id"],
        ),
        sa.ForeignKeyConstraint(
            ["video_tag_id"],
            ["nei.video_tag.id"],
        ),
        sa.PrimaryKeyConstraint("video_id", "video_tag_id"),
        schema=settings.SCHEMA_NAME,
    )


def downgrade() -> None:
    op.drop_table("video__video_tags", schema=settings.SCHEMA_NAME)
    op.drop_index(
        op.f("ix_nei_user_matriculation_user_id"),
        table_name="user_matriculation",
        schema=settings.SCHEMA_NAME,
    )
    op.drop_index(
        op.f("ix_nei_user_matriculation_created_at"),
        table_name="user_matriculation",
        schema=settings.SCHEMA_NAME,
    )
    op.drop_index(
        op.f("ix_nei_user_matriculation_course_id"),
        table_name="user_matriculation",
        schema=settings.SCHEMA_NAME,
    )
    op.drop_table("user_matriculation", schema=settings.SCHEMA_NAME)
    op.drop_table("user_email", schema=settings.SCHEMA_NAME)
    op.drop_index(
        op.f("ix_nei_team_member_user_id"),
        table_name="team_member",
        schema=settings.SCHEMA_NAME,
    )
    op.drop_index(
        op.f("ix_nei_team_member_role_id"),
        table_name="team_member",
        schema=settings.SCHEMA_NAME,
    )
    op.drop_index(
        op.f("ix_nei_team_member_mandate"),
        table_name="team_member",
        schema=settings.SCHEMA_NAME,
    )
    op.drop_table("team_member", schema=settings.SCHEMA_NAME)
    op.drop_table("team_colaborator", schema=settings.SCHEMA_NAME)
    op.drop_table("senior_student", schema=settings.SCHEMA_NAME)
    op.drop_index(
        op.f("ix_nei_note_year"), table_name="note", schema=settings.SCHEMA_NAME
    )
    op.drop_index(
        op.f("ix_nei_note_teacher_id"), table_name="note", schema=settings.SCHEMA_NAME
    )
    op.drop_index(
        op.f("ix_nei_note_subject_id"), table_name="note", schema=settings.SCHEMA_NAME
    )
    op.drop_index(
        op.f("ix_nei_note_created_at"), table_name="note", schema=settings.SCHEMA_NAME
    )
    op.drop_index(
        op.f("ix_nei_note_author_id"), table_name="note", schema=settings.SCHEMA_NAME
    )
    op.drop_table("note", schema=settings.SCHEMA_NAME)
    op.drop_index(
        op.f("ix_nei_news_author_id"), table_name="news", schema=settings.SCHEMA_NAME
    )
    op.drop_table("news", schema=settings.SCHEMA_NAME)
    op.drop_index(
        op.f("ix_nei_faina_member_role_id"),
        table_name="faina_member",
        schema=settings.SCHEMA_NAME,
    )
    op.drop_index(
        op.f("ix_nei_faina_member_member_id"),
        table_name="faina_member",
        schema=settings.SCHEMA_NAME,
    )
    op.drop_index(
        op.f("ix_nei_faina_member_faina_id"),
        table_name="faina_member",
        schema=settings.SCHEMA_NAME,
    )
    op.drop_table("faina_member", schema=settings.SCHEMA_NAME)
    op.drop_table("device_login", schema=settings.SCHEMA_NAME)
    op.drop_table("video_tag", schema=settings.SCHEMA_NAME)
    op.drop_index(
        op.f("ix_nei_video_created_at"), table_name="video", schema=settings.SCHEMA_NAME
    )
    op.drop_table("video", schema=settings.SCHEMA_NAME)
    op.drop_index(
        op.f("ix_nei_user_updated_at"), table_name="user", schema=settings.SCHEMA_NAME
    )
    op.drop_index(
        op.f("ix_nei_user_created_at"), table_name="user", schema=settings.SCHEMA_NAME
    )
    op.drop_table("user", schema=settings.SCHEMA_NAME)
    op.drop_index(
        op.f("ix_nei_team_role_weight"),
        table_name="team_role",
        schema=settings.SCHEMA_NAME,
    )
    op.drop_table("team_role", schema=settings.SCHEMA_NAME)
    op.drop_table("teacher", schema=settings.SCHEMA_NAME)
    op.drop_table("subject", schema=settings.SCHEMA_NAME)
    op.drop_table("senior", schema=settings.SCHEMA_NAME)
    op.drop_index(
        op.f("ix_nei_rgm_mandate"), table_name="rgm", schema=settings.SCHEMA_NAME
    )
    op.drop_table("rgm", schema=settings.SCHEMA_NAME)
    op.drop_table("redirect", schema=settings.SCHEMA_NAME)
    op.drop_table("partner", schema=settings.SCHEMA_NAME)
    op.drop_table("merch", schema=settings.SCHEMA_NAME)
    op.drop_table("history", schema=settings.SCHEMA_NAME)
    op.drop_table("faina_role", schema=settings.SCHEMA_NAME)
    op.drop_table("faina", schema=settings.SCHEMA_NAME)
    op.drop_table("course", schema=settings.SCHEMA_NAME)
    scopes_enum = postgresql.ENUM(
        name="scope_enum",
        schema=settings.SCHEMA_NAME,
        inherit_schema=True,
        create_type=False,
    )
    scopes_enum.drop(op.get_bind(), checkfirst=False)
    gender_enum = postgresql.ENUM(
        name="gender_enum",
        schema=settings.SCHEMA_NAME,
        inherit_schema=True,
        create_type=False,
    )
    gender_enum.drop(op.get_bind(), checkfirst=False)
    category_enum = postgresql.ENUM(
        name="category_enum",
        schema=settings.SCHEMA_NAME,
        inherit_schema=True,
        create_type=False,
    )
    category_enum.drop(op.get_bind(), checkfirst=False)
