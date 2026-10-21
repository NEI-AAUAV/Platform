"""history: mandate/slug domain checks, stable category slugs, cover alt text

Revision ID: b7d9f1a3c5e8
Revises: e2b4d6f8a1c3
Create Date: 2026-09-27

Directus writes straight to PostgreSQL (see c3f5a7b9d1e2), so the invariants
the public timeline relies on live in the schema:

* history.mandate is AAAA/AA: the page sorts, labels and builds anchors
  from it. NULL stays allowed (the page derives it from `moment`).
* history_category.slug is lowercase letters, digits and hyphens — the same
  rule Directus validates — because it is the `?categoria=<slug>` value in
  shared links.
* history_category.slug never changes once created (trigger), so those
  shared links keep working. Renaming a category is a `label` edit; a real
  new identifier is a new category.

Adds history.image_alt: an editor-written description of the cover image,
blank for decorative covers. The Directus field for it is configured in
Infrastructure (services/directus), like every other CMS field.

Existing rows are checked first; a clear error lists offenders instead of a
generic constraint failure.
"""

from alembic import op
import sqlalchemy as sa


revision = "b7d9f1a3c5e8"
down_revision = "e2b4d6f8a1c3"
branch_labels = None
depends_on = None

S = "nei"

CHECKS = [
    ("history", "mandate_format", "mandate ~ '^[0-9]{4}/[0-9]{2}$'"),
    ("history_category", "slug_format", "slug ~ '^[a-z0-9-]+$'"),
]

SLUG_GUARD_FUNCTION = f"{S}.history_category_slug_immutable"
SLUG_GUARD_TRIGGER = "history_category_slug_immutable"


def _fail_on(conn, table: str, name: str, expr: str) -> None:
    bad = conn.execute(
        sa.text(f"SELECT id FROM {S}.{table} WHERE NOT COALESCE(({expr}), TRUE)")
    ).scalars().all()
    if bad:
        raise RuntimeError(
            f"{table} rows violating {name} ({expr}): ids {bad}. Fix them before migrating."
        )


def upgrade() -> None:
    conn = op.get_bind()
    for table, name, expr in CHECKS:
        _fail_on(conn, table, name, expr)
    for table, name, expr in CHECKS:
        op.create_check_constraint(op.f(f"ck_{table}_{name}"), table, expr, schema=S)

    op.execute(
        f"""
        CREATE FUNCTION {SLUG_GUARD_FUNCTION}() RETURNS trigger
        LANGUAGE plpgsql AS $$
        BEGIN
            IF NEW.slug IS DISTINCT FROM OLD.slug THEN
                RAISE EXCEPTION
                    'history_category.slug cannot change (% -> %): shared ?categoria= links depend on it. Edit the label instead, or create a new category.',
                    OLD.slug, NEW.slug
                    USING ERRCODE = 'check_violation';
            END IF;
            RETURN NEW;
        END;
        $$
        """
    )
    op.execute(
        f"""
        CREATE TRIGGER {SLUG_GUARD_TRIGGER}
        BEFORE UPDATE OF slug ON {S}.history_category
        FOR EACH ROW EXECUTE FUNCTION {SLUG_GUARD_FUNCTION}()
        """
    )

    op.add_column("history", sa.Column("image_alt", sa.String(200), nullable=True), schema=S)


def downgrade() -> None:
    op.drop_column("history", "image_alt", schema=S)
    op.execute(f"DROP TRIGGER IF EXISTS {SLUG_GUARD_TRIGGER} ON {S}.history_category")
    op.execute(f"DROP FUNCTION IF EXISTS {SLUG_GUARD_FUNCTION}()")
    for table, name, _ in reversed(CHECKS):
        op.drop_constraint(op.f(f"ck_{table}_{name}"), table, schema=S, type_="check")
