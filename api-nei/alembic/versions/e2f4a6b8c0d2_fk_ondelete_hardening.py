"""harden ondelete behavior on child/junction table FKs

Revision ID: e2f4a6b8c0d2
Revises: c5e7a9b1d3f6
Create Date: 2026-09-23

Several FKs were created with no `ondelete`, defaulting to Postgres's
`NO ACTION`. Deleting the parent row (e.g. a `faina`) then fails with a
foreign key violation instead of doing the sensible thing.

- faina_member.faina_id, senior_student.senior_id/user_id,
  video__video_tags.video_id/video_tag_id, user_matriculation.user_id:
  pure child/junction rows with no meaning once the parent is gone ->
  CASCADE.
- user.for_event, note.author_id, note.teacher_id: optional references
  where the row should survive the parent's deletion -> SET NULL.

Deliberately NOT touched here: faina_member.member_id (nullable, but a
CHECK constraint requires `name` be set whenever it's NULL — blindly
nulling it on user delete can trip that CHECK instead; needs app-level
handling), news.author_id (NOT NULL, would need a separate decision to
make nullable first), and anything pointing at reference/lookup tables
(role, course, subject) which are not routinely deleted.
"""

from alembic import op


revision = "e2f4a6b8c0d2"
down_revision = "c5e7a9b1d3f6"
branch_labels = None
depends_on = None

SCHEMA = "nei"

# (constraint_name, table, [local_col], target_table, [target_col], ondelete)
FKS = [
    ("fk_faina_member_faina_id_faina", "faina_member", ["faina_id"], "faina", ["id"], "CASCADE"),
    ("fk_senior_student_senior_id_senior", "senior_student", ["senior_id"], "senior", ["id"], "CASCADE"),
    ("fk_senior_student_user_id_user", "senior_student", ["user_id"], "user", ["id"], "CASCADE"),
    ("fk_video__video_tags_video_id_video", "video__video_tags", ["video_id"], "video", ["id"], "CASCADE"),
    ("fk_video__video_tags_video_tag_id_video_tag", "video__video_tags", ["video_tag_id"], "video_tag", ["id"], "CASCADE"),
    ("fk_user_matriculation_user_id_user", "user_matriculation", ["user_id"], "user", ["id"], "CASCADE"),
    ("fk_user_for_event_event", "user", ["for_event"], "event", ["id"], "SET NULL"),
    ("fk_author_id", "note", ["author_id"], "user", ["id"], "SET NULL"),
    ("fk_teacher_id", "note", ["teacher_id"], "teacher", ["id"], "SET NULL"),
]


def upgrade() -> None:
    for name, table, cols, target_table, target_cols, ondelete in FKS:
        op.drop_constraint(op.f(name), table, schema=SCHEMA, type_="foreignkey")
        op.create_foreign_key(
            op.f(name),
            table,
            target_table,
            cols,
            target_cols,
            source_schema=SCHEMA,
            referent_schema=SCHEMA,
            ondelete=ondelete,
        )


def downgrade() -> None:
    for name, table, cols, target_table, target_cols, _ in FKS:
        op.drop_constraint(op.f(name), table, schema=SCHEMA, type_="foreignkey")
        op.create_foreign_key(
            op.f(name),
            table,
            target_table,
            cols,
            target_cols,
            source_schema=SCHEMA,
            referent_schema=SCHEMA,
        )
