"""history_media: name the single-source check by the convention

Revision ID: d4f6a8c0e2b3
Revises: b7d9f1a3c5e8
Create Date: 2026-09-27

a3f5c7e9b1d4 first passed the already-prefixed name to `sa.CheckConstraint`
without `op.f()`, so the naming convention prefixed it again and databases
upgraded with that version hold `ck_history_media_ck_history_media_single_source`.
The revision is fixed now; this renames the constraint on those databases so
every environment matches the model (`ck_history_media_single_source`).
No-op where the name is already right.
"""

from alembic import op


revision = "d4f6a8c0e2b3"
down_revision = "b7d9f1a3c5e8"
branch_labels = None
depends_on = None

S = "nei"
DOUBLED = "ck_history_media_ck_history_media_single_source"
NAME = "ck_history_media_single_source"


def _rename(old: str, new: str) -> None:
    op.execute(
        f"""
        DO $$
        BEGIN
            IF EXISTS (
                SELECT 1 FROM pg_constraint
                WHERE conrelid = '{S}.history_media'::regclass AND conname = '{old}'
            ) THEN
                ALTER TABLE {S}.history_media RENAME CONSTRAINT {old} TO {new};
            END IF;
        END
        $$
        """
    )


def upgrade() -> None:
    _rename(DOUBLED, NAME)


def downgrade() -> None:
    # The fixed a3f5c7e9b1d4 creates NAME too: nothing to restore.
    pass
