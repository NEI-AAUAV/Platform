"""legacy columns become optional and flags get domain defaults

Revision ID: b9d1f3a5c7e8
Revises: a8c0e2f4b6d7
Create Date: 2026-09-19

Creating content from the CMS (which only writes the managed `*_asset` /
`mandate_id` columns) was impossible: the legacy string columns
`rgm.file`, `rgm.mandate` and `note.location` were NOT NULL, and several flag
columns had no default. These are domain fixes, not CMS concessions:

* `rgm.file`, `note.location`: legacy fallbacks that an uploaded asset
  supersedes -> nullable.
* `rgm.mandate`: legacy text; the authoritative link is `rgm.mandate_id`
  (-> rgm_mandate). Backfilled here, then nullable; the API now derives the
  mandate from the relation (falling back to the legacy text).
* `news.public` defaults to false (unpublished), `merch.discontinued` to
  false, `note.summary..notebook` to 0.
"""
from alembic import op

revision = "b9d1f3a5c7e8"
down_revision = "a8c0e2f4b6d7"
branch_labels = None
depends_on = None

S = "nei"
NOTE_FLAGS = ["summary", "tests", "bibliography", "slides", "exercises", "projects", "notebook"]


def upgrade() -> None:
    op.execute(
        f"INSERT INTO {S}.rgm_mandate (label) SELECT DISTINCT mandate FROM {S}.rgm"
        f" WHERE mandate IS NOT NULL AND mandate NOT IN (SELECT label FROM {S}.rgm_mandate)"
    )
    op.execute(
        f"UPDATE {S}.rgm r SET mandate_id = m.id FROM {S}.rgm_mandate m"
        " WHERE r.mandate_id IS NULL AND m.label = r.mandate"
    )
    for tbl, col in [("rgm", "file"), ("rgm", "mandate"), ("note", "location")]:
        op.execute(f"ALTER TABLE {S}.{tbl} ALTER COLUMN {col} DROP NOT NULL")
    op.execute(f"ALTER TABLE {S}.news ALTER COLUMN public SET DEFAULT false")
    op.execute(f"ALTER TABLE {S}.merch ALTER COLUMN discontinued SET DEFAULT false")
    for c in NOTE_FLAGS:
        op.execute(f"ALTER TABLE {S}.note ALTER COLUMN {c} SET DEFAULT 0")


def downgrade() -> None:
    for c in NOTE_FLAGS:
        op.execute(f"ALTER TABLE {S}.note ALTER COLUMN {c} DROP DEFAULT")
    op.execute(f"ALTER TABLE {S}.merch ALTER COLUMN discontinued DROP DEFAULT")
    op.execute(f"ALTER TABLE {S}.news ALTER COLUMN public DROP DEFAULT")
    # Restoring NOT NULL: derive legacy values first so it cannot fail.
    op.execute(
        f"UPDATE {S}.rgm r SET mandate = m.label FROM {S}.rgm_mandate m"
        " WHERE r.mandate IS NULL AND m.id = r.mandate_id"
    )
    op.execute(f"UPDATE {S}.rgm SET file = '' WHERE file IS NULL")
    op.execute(f"UPDATE {S}.note SET location = '' WHERE location IS NULL")
    for tbl, col in [("rgm", "file"), ("rgm", "mandate"), ("note", "location")]:
        op.execute(f"ALTER TABLE {S}.{tbl} ALTER COLUMN {col} SET NOT NULL")
