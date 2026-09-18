"""Data-integrity tests for the Team domain.

No dedicated tests existed for team_* before this pass (zero coverage).
These focus on the invariants the Directus refactor depends on:
team_colaborator's surrogate PK, and the team_member.mandate
denormalization staying consistent with section_id (the actual source of
truth).
"""
from datetime import datetime

import pytest
from sqlalchemy.exc import IntegrityError

from app.models.team.team_mandate import TeamMandate
from app.models.team.team_category import TeamCategory
from app.models.team.team_section import TeamSection
from app.models.team.team_member import TeamMember
from app.models.team.team_colaborator import TeamColaborator
from app.models.user import User
from app.tests.conftest import SessionTesting


def _make_user(db: SessionTesting, name: str, surname: str) -> User:
    user = User(
        name=name,
        surname=surname,
        created_at=datetime(2026, 1, 1),
        updated_at=datetime(2026, 1, 1),
    )
    db.add(user)
    db.flush()
    return user


def _make_mandate_section(db: SessionTesting, mandate: str) -> TeamSection:
    m = TeamMandate(mandate=mandate)
    db.add(m)
    db.flush()
    category = TeamCategory(mandate=mandate, name="Coordenação", weight=0)
    db.add(category)
    db.flush()
    section = TeamSection(category_id=category.id, name="Coordenação", weight=0)
    db.add(section)
    db.flush()
    return section


def test_team_member_mandate_matches_section_mandate_when_set(db: SessionTesting) -> None:
    """team_member.mandate is a denormalization of section -> category ->
    mandate. When populated (as the CMS refactor's read-only field does),
    it must agree with the value reachable through section_id — that's
    the whole point of keeping section_id authoritative."""
    section = _make_mandate_section(db, "2025/26")

    member = TeamMember(name="Ana", role="Coordenadora", section_id=section.id, mandate="2025/26")
    db.add(member)
    db.flush()

    db.refresh(member)
    assert member.mandate == member.section.category.mandate


def test_team_member_mandate_can_be_null(db: SessionTesting) -> None:
    """The denormalized column is nullable — a member created without it
    set (e.g. directly via the API, bypassing the CMS backfill) must not
    be rejected by the schema."""
    section = _make_mandate_section(db, "2026/27")

    member = TeamMember(name="Bruno", role="Vogal", section_id=section.id)
    db.add(member)
    db.flush()

    assert member.mandate is None


def test_team_colaborator_has_surrogate_id_primary_key(db: SessionTesting) -> None:
    """Directus cannot manage a table with a composite primary key.
    team_colaborator was given a surrogate `id` (alembic migration
    b5c7d9e1f3a5) specifically so it can be onboarded as a collection —
    confirm the model maps that id, not the old (user_id, mandate) pair."""
    user = _make_user(db, "Carla", "Costa")

    colaborator = TeamColaborator(user_id=user.id, mandate="2025/26")
    db.add(colaborator)
    db.flush()

    assert colaborator.id is not None


def test_team_colaborator_uniqueness_preserved_after_pk_change(db: SessionTesting) -> None:
    """The old (user_id, mandate) pair was preserved as a UNIQUE
    constraint when the PK became a surrogate id — a duplicate pair must
    still be rejected, exactly as it was under the old composite PK."""
    user = _make_user(db, "Diana", "Duarte")

    db.add(TeamColaborator(user_id=user.id, mandate="2025/26"))
    db.flush()

    db.add(TeamColaborator(user_id=user.id, mandate="2025/26"))
    with pytest.raises(IntegrityError):
        db.flush()
