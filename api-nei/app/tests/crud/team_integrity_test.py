"""Integrity tests for the Team domain: mandate -> section -> member.

These assert that invalid states are rejected by the database itself, not
just by the API layer or the CMS form configuration.
"""
from datetime import datetime

import pytest
import sqlalchemy as sa
from sqlalchemy.exc import IntegrityError

from app.core.config import settings
from app.models.team.team_mandate import TeamMandate
from app.models.team.team_member import TeamMember
from app.models.team.team_section import TeamSection
from app.models.user import User
from app.tests.conftest import SessionTesting

S = settings.SCHEMA_NAME


def _mandate(db: SessionTesting, mandate: str) -> TeamMandate:
    m = TeamMandate(mandate=mandate)
    db.add(m)
    db.flush()
    return m


def _section(db: SessionTesting, mandate: str, name: str = "Coordenação") -> TeamSection:
    mandate_id = db.execute(
        sa.text(f"SELECT id FROM {S}.team_mandate WHERE mandate = :m"), {"m": mandate}
    ).scalar_one()
    s = TeamSection(mandate_id=mandate_id, name=name, weight=0)
    db.add(s)
    db.flush()
    return s


def test_section_requires_existing_mandate(db: SessionTesting) -> None:
    db.add(TeamSection(mandate_id=-1, name="Órfã", weight=0))
    with pytest.raises(IntegrityError):
        db.flush()


def test_section_mandate_is_not_null(db: SessionTesting) -> None:
    stmt = sa.text(f"INSERT INTO {S}.team_section (name, weight) VALUES ('x', 0)")
    with pytest.raises(IntegrityError):
        db.execute(stmt)


def test_member_requires_existing_section(db: SessionTesting) -> None:
    db.add(TeamMember(section_id=-1, name="Ana", role="Vogal"))
    with pytest.raises(IntegrityError):
        db.flush()


def test_member_name_cannot_be_null(db: SessionTesting) -> None:
    _mandate(db, "2025/26")
    section = _section(db, "2025/26")
    stmt = sa.text(
        f"INSERT INTO {S}.team_member (section_id, role, weight)"
        " VALUES (:s, 'Vogal', 0)"
    )
    with pytest.raises(IntegrityError):
        db.execute(stmt, {"s": section.id})


@pytest.mark.parametrize("blank", ["", "   "])
def test_member_name_cannot_be_blank(db: SessionTesting, blank: str) -> None:
    _mandate(db, "2025/26")
    section = _section(db, "2025/26")
    db.add(TeamMember(section_id=section.id, name=blank, role="Vogal"))
    with pytest.raises(IntegrityError):
        db.flush()


def test_member_without_user_is_valid(db: SessionTesting) -> None:
    """A member is an editorial entry, independent of any platform account."""
    _mandate(db, "2025/26")
    section = _section(db, "2025/26")
    member = TeamMember(section_id=section.id, name="Bruno", role="Vogal")
    db.add(member)
    db.flush()
    assert member.user_id is None


def test_member_has_no_denormalized_mandate_column(db: SessionTesting) -> None:
    columns = {c["name"] for c in sa.inspect(db.get_bind()).get_columns("team_member", schema=S)}
    assert "mandate" not in columns


def test_category_and_legacy_tables_are_gone(db: SessionTesting) -> None:
    tables = set(sa.inspect(db.get_bind()).get_table_names(schema=S))
    assert not {"team_category", "team_role", "team_colaborator"} & tables


def test_deleting_section_deletes_its_members(db: SessionTesting) -> None:
    _mandate(db, "2025/26")
    section = _section(db, "2025/26")
    db.add(TeamMember(section_id=section.id, name="Carla", role="Vogal"))
    db.flush()
    db.execute(sa.text(f"DELETE FROM {S}.team_section WHERE id = :s"), {"s": section.id})
    left = db.execute(
        sa.text(f"SELECT count(*) FROM {S}.team_member WHERE section_id = :s"),
        {"s": section.id},
    ).scalar_one()
    assert left == 0


def test_deleting_mandate_deletes_sections(db: SessionTesting) -> None:
    _mandate(db, "2024/25")
    section = _section(db, "2024/25")
    db.execute(sa.text(f"DELETE FROM {S}.team_mandate WHERE mandate = '2024/25'"))
    left = db.execute(
        sa.text(f"SELECT count(*) FROM {S}.team_section WHERE id = :s"), {"s": section.id}
    ).scalar_one()
    assert left == 0


def test_user_linked_member_keeps_own_name(db: SessionTesting) -> None:
    user = User(
        name="Diana",
        surname="Duarte",
        created_at=datetime(2026, 1, 1),
        updated_at=datetime(2026, 1, 1),
    )
    db.add(user)
    db.flush()
    _mandate(db, "2025/26")
    section = _section(db, "2025/26")
    member = TeamMember(section_id=section.id, user_id=user.id, name="Di", role="Vogal")
    db.add(member)
    db.flush()
    db.refresh(member)
    assert member.name == "Di"


# ---- generated mandate id, unique string, section -> mandate_id ------------
def test_team_mandate_id_is_generated(db: SessionTesting) -> None:
    mandate = _mandate(db, "2090/91")
    assert mandate.id is not None


def test_team_mandate_id_is_generated_by_the_database(db: SessionTesting) -> None:
    """Raw insert, as Directus does: no Python-side default involved."""
    new_id = db.execute(
        sa.text(f"INSERT INTO {S}.team_mandate (mandate) VALUES ('2091/92') RETURNING id")
    ).scalar_one()
    assert isinstance(new_id, int)


def test_team_mandate_string_is_unique(db: SessionTesting) -> None:
    _mandate(db, "2090/91")
    db.add(TeamMandate(mandate="2090/91"))
    with pytest.raises(IntegrityError):
        db.flush()


@pytest.mark.parametrize("bad", ["2090", "90/91", "2090-91", "2090/9", "abcd/ef"])
def test_team_mandate_format_is_enforced(db: SessionTesting, bad: str) -> None:
    db.add(TeamMandate(mandate=bad))
    with pytest.raises(IntegrityError):
        db.flush()


def test_team_mandate_primary_key_is_id(db: SessionTesting) -> None:
    pk = sa.inspect(db.get_bind()).get_pk_constraint("team_mandate", schema=S)
    assert pk["constrained_columns"] == ["id"]


def test_section_references_mandate_id(db: SessionTesting) -> None:
    mandate = _mandate(db, "2090/91")
    section = _section(db, "2090/91")
    assert section.mandate_id == mandate.id
    fks = sa.inspect(db.get_bind()).get_foreign_keys("team_section", schema=S)
    ref = {fk["constrained_columns"][0]: fk["referred_columns"][0] for fk in fks}
    assert ref["mandate_id"] == "id"
    columns = {c["name"] for c in sa.inspect(db.get_bind()).get_columns("team_section", schema=S)}
    assert "mandate" not in columns


def test_every_generated_id_is_database_generated(db: SessionTesting) -> None:
    """No content table may require an editor to supply its `id`."""
    insp = sa.inspect(db.get_bind())
    missing = []
    for table in insp.get_table_names(schema=S):
        pk = insp.get_pk_constraint(table, schema=S)["constrained_columns"]
        if pk != ["id"]:
            continue
        col = next(c for c in insp.get_columns(table, schema=S) if c["name"] == "id")
        if not (col.get("default") or col.get("identity") or col.get("autoincrement") is True):
            missing.append(table)
    assert not missing, missing
