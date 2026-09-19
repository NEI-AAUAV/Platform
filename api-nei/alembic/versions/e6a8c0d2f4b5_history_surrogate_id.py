"""history gets a surrogate primary key; the date is no longer its identity

Revision ID: e6a8c0d2f4b5
Revises: d5f7b9c1e3a4
Create Date: 2026-09-19

`history.moment` (a DATE) was the primary key, so two events on the same day
were impossible and changing an event's date changed its identity. The
identity is now `id BIGSERIAL`; `moment` stays NOT NULL and is indexed.

Existing rows get ids in chronological order. The old primary key constraint
is looked up by catalog rather than by name because it was created unnamed.

Downgrade restores `moment` as the primary key and fails (Postgres will
refuse to add the constraint) if two events now share a date; that is the
correct outcome, the old model cannot represent them.
"""

from alembic import op
import sqlalchemy as sa


revision = "e6a8c0d2f4b5"
down_revision = "d5f7b9c1e3a4"
branch_labels = None
depends_on = None

SCHEMA = "nei"


def upgrade() -> None:
    op.execute(
        f"""
        DO $$
        DECLARE pk text;
        BEGIN
            SELECT conname INTO pk FROM pg_constraint
            WHERE conrelid = '{SCHEMA}.history'::regclass AND contype = 'p';
            IF pk IS NOT NULL THEN
                EXECUTE format('ALTER TABLE {SCHEMA}.history DROP CONSTRAINT %I', pk);
            END IF;
        END $$;
        """
    )
    op.execute(f"ALTER TABLE {SCHEMA}.history ADD COLUMN id BIGINT")
    op.execute(
        f"""
        UPDATE {SCHEMA}.history h SET id = r.rn
        FROM (SELECT moment, ROW_NUMBER() OVER (ORDER BY moment) AS rn
              FROM {SCHEMA}.history) r
        WHERE r.moment = h.moment
        """
    )
    op.execute(f"CREATE SEQUENCE {SCHEMA}.history_id_seq OWNED BY {SCHEMA}.history.id")
    op.execute(
        f"SELECT setval('{SCHEMA}.history_id_seq',"
        f" COALESCE((SELECT MAX(id) FROM {SCHEMA}.history), 0) + 1, false)"
    )
    op.execute(
        f"ALTER TABLE {SCHEMA}.history"
        f" ALTER COLUMN id SET DEFAULT nextval('{SCHEMA}.history_id_seq'),"
        " ALTER COLUMN id SET NOT NULL"
    )
    op.execute(
        f"ALTER TABLE {SCHEMA}.history"
        " ADD CONSTRAINT pk_history PRIMARY KEY (id)"
    )
    op.create_index(op.f("ix_nei_history_moment"), "history", ["moment"], schema=SCHEMA)


def downgrade() -> None:
    op.drop_index(op.f("ix_nei_history_moment"), table_name="history", schema=SCHEMA)
    op.execute(f"ALTER TABLE {SCHEMA}.history DROP CONSTRAINT pk_history")
    op.execute(f"ALTER TABLE {SCHEMA}.history ADD CONSTRAINT pk_history PRIMARY KEY (moment)")
    op.execute(f"ALTER TABLE {SCHEMA}.history DROP COLUMN id")
