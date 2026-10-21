"""allow rgm.category 'ACR' (anexo complementar ao RAC)

Revision ID: e1a3c5b7d9f2
Revises: d6f8b0c2e4a7
Create Date: 2026-10-21

Widens ck_rgm_category_valid (from c3f5a7b9d1e2) so Directus can store the
new document type. Downgrade fails if any 'ACR' rows exist rather than
silently dropping the constraint.
"""
from alembic import op

from app.core.config import settings

revision = "e1a3c5b7d9f2"
down_revision = "d6f8b0c2e4a7"
branch_labels = None
depends_on = None

S = settings.SCHEMA_NAME
NAME = "ck_rgm_category_valid"


def _replace(expr: str) -> None:
    op.drop_constraint(op.f(NAME), "rgm", schema=S, type_="check")
    op.create_check_constraint(op.f(NAME), "rgm", expr, schema=S)


def upgrade():
    _replace("category IN ('ATA', 'PAO', 'RAC', 'CON', 'ACR')")


def downgrade():
    _replace("category IN ('ATA', 'PAO', 'RAC', 'CON')")
