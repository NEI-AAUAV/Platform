"""Migration-chain guards: one head, no model drift, no Directus infra in Alembic."""
import re
from pathlib import Path

from alembic import command
from alembic.script import ScriptDirectory

from app.tests.conftest import _alembic_config

VERSIONS = Path(__file__).resolve().parents[2] / "alembic" / "versions"

# Revisions that used to provision Directus and are now intentional no-ops.
RETIRED = {
    "d3c7f0a1b2e4",
    "f2b4d8e1a9c3",
    "e8f0a2b4c6d8",
    "f9a1b3c5d7e9",
    "b5c7d9e1f3a5",
}


def test_single_alembic_head() -> None:
    heads = ScriptDirectory.from_config(_alembic_config()).get_heads()
    assert len(heads) == 1, heads


def test_models_match_migrated_schema(connection) -> None:
    """`alembic check`: fails if a model differs from what the chain builds."""
    command.check(_alembic_config())


def test_alembic_does_not_own_directus_infrastructure() -> None:
    """Role/schema/grants for Directus belong to the Infrastructure repository."""
    forbidden = re.compile(r"CREATE ROLE|ALTER ROLE|GRANT\s|REVOKE\s|directus_svc", re.I)
    offenders = []
    for path in VERSIONS.glob("*.py"):
        rev = path.name.split("_")[0]
        text = path.read_text()
        if rev in RETIRED:
            # Retired revisions may only *mention* the role in their docstring.
            body = text.split('"""', 2)[-1]
            if forbidden.search(body):
                offenders.append(path.name)
        elif forbidden.search(re.sub(r'""".*?"""', "", text, flags=re.S)):
            offenders.append(path.name)
    assert not offenders, offenders
