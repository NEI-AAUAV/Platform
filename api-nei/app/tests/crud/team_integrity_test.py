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
    s = TeamSection(mandate=mandate, name=name, weight=0)
    db.add(s)
    db.flush()
    return s


def test_section_requires_existing_mandate(db: SessionTesting) -> None:
    db.add(TeamSection(mandate="1999/00", name="Órfã", weight=0))
    with pytest.raises(IntegrityError):
        db.flush()


def test_section_mandate_is_not_null(db: SessionTesting) -> None:
    with pytest.raises(IntegrityError):
        db.execute(sa.text(f"INSERT INTO {S}.team_section (name, weight) VALUES ('x', 0)"))


def test_member_requires_existing_section(db: SessionTesting) -> None:
    db.add(TeamMember(section_id=-1, name="Ana", role="Vogal"))
    with pytest.raises(IntegrityError):
        db.flush()


def test_member_name_cannot_be_null(db: SessionTesting) -> None:
    _mandate(db, "2025/26")
    section = _section(db, "2025/26")
    with pytest.raises(IntegrityError):
        db.execute(
            sa.text(
                f"INSERT INTO {S}.team_member (section_id, role, weight)"
                " VALUES (:s, 'Vogal', 0)"
            ),
            {"s": section.id},
        )


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
