"""give team_colaborator a surrogate primary key

Revision ID: b5c7d9e1f3a5
Revises: a4b6c8d0e2f4
Create Date: 2026-09-18

Ports Infrastructure/services/directus/sql/03-team-colaborator-pk.sql into
Alembic, closing the last schema-ownership gap for this table: Directus
does not support composite primary keys on a managed collection, so
`team_colaborator` (previously PK'd on `(user_id, mandate)`) gets a
single-column surrogate `id` instead. The old pair is preserved exactly as
a UNIQUE constraint, so nothing that relied on that uniqueness breaks.

`app/models/team/team_colaborator.py` is updated in the same change to map
`id` as the primary key.
"""
from alembic import op
import sqlalchemy as sa

# revision identifiers, used by Alembic.
revision = "b5c7d9e1f3a5"
down_revision = "a4b6c8d0e2f4"
branch_labels = None
depends_on = None

SCHEMA = "nei"
TABLE = "team_colaborator"


def upgrade():
    op.add_column(
        TABLE,
        sa.Column("id", sa.BigInteger(), nullable=True),
        schema=SCHEMA,
    )
    op.execute(
        f"""
        CREATE SEQUENCE IF NOT EXISTS {SCHEMA}.{TABLE}_id_seq
            OWNED BY {SCHEMA}.{TABLE}.id;
        SELECT setval(
            '{SCHEMA}.{TABLE}_id_seq',
            COALESCE((SELECT max(id) FROM {SCHEMA}.{TABLE}), 0) + 1,
            false
        );
        ALTER TABLE {SCHEMA}.{TABLE}
            ALTER COLUMN id SET DEFAULT nextval('{SCHEMA}.{TABLE}_id_seq');
        UPDATE {SCHEMA}.{TABLE} SET id = nextval('{SCHEMA}.{TABLE}_id_seq')
            WHERE id IS NULL;
        ALTER TABLE {SCHEMA}.{TABLE} ALTER COLUMN id SET NOT NULL;
        ALTER TABLE {SCHEMA}.{TABLE} DROP CONSTRAINT IF EXISTS pk_team_colaborator;
        ALTER TABLE {SCHEMA}.{TABLE}
            ADD CONSTRAINT uq_team_colaborator_user_mandate UNIQUE (user_id, mandate);
        ALTER TABLE {SCHEMA}.{TABLE} ADD CONSTRAINT pk_team_colaborator_id PRIMARY KEY (id);
        """
    )
    op.execute(f"GRANT USAGE, SELECT ON {SCHEMA}.{TABLE}_id_seq TO directus_svc;")


def downgrade():
    op.execute(
        f"""
        ALTER TABLE {SCHEMA}.{TABLE} DROP CONSTRAINT IF EXISTS pk_team_colaborator_id;
        ALTER TABLE {SCHEMA}.{TABLE} DROP CONSTRAINT IF EXISTS uq_team_colaborator_user_mandate;
        ALTER TABLE {SCHEMA}.{TABLE} ADD CONSTRAINT pk_team_colaborator PRIMARY KEY (user_id, mandate);
        ALTER TABLE {SCHEMA}.{TABLE} ALTER COLUMN id DROP DEFAULT;
        DROP SEQUENCE IF EXISTS {SCHEMA}.{TABLE}_id_seq;
        """
    )
    op.drop_column(TABLE, "id", schema=SCHEMA)
