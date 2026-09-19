"""nei.* must not have foreign keys into the directus schema

Revision ID: a8c0e2f4b6d7
Revises: f7b9d1e3a5c6
Create Date: 2026-09-19

Directus asset ids are stored in plain UUID `*_asset` columns on purpose:
application tables must not depend on Directus' own schema, so the two can
be migrated and deployed independently. Older Directus provisioning (SQL run
from the Infrastructure repository, since removed) created real foreign keys
such as `team_member_header_asset_foreign -> directus.directus_files` on some
databases. This drops any such constraint. It is a no-op where none exist,
and it is a constraint on *our* schema, so it belongs to this chain.

The downgrade does nothing: the constraints were an accident of retired
tooling and must not be recreated.
"""
from alembic import op

revision = "a8c0e2f4b6d7"
down_revision = "f7b9d1e3a5c6"
branch_labels = None
depends_on = None

SCHEMA = "nei"


def upgrade() -> None:
    op.execute(
        f"""
        DO $$
        DECLARE r record;
        BEGIN
            IF to_regnamespace('directus') IS NULL THEN
                RETURN;
            END IF;
            FOR r IN
                SELECT c.conrelid::regclass AS tbl, c.conname
                FROM pg_constraint c
                JOIN pg_class ref ON ref.oid = c.confrelid
                WHERE c.contype = 'f'
                  AND c.connamespace = '{SCHEMA}'::regnamespace
                  AND ref.relnamespace = 'directus'::regnamespace
            LOOP
                EXECUTE format('ALTER TABLE %s DROP CONSTRAINT %I', r.tbl, r.conname);
            END LOOP;
        END $$;
        """
    )


def downgrade() -> None:
    pass
