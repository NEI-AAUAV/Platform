"""Behaviour of the generic CRUDBase that every entity CRUD inherits."""
import pytest
from fastapi import HTTPException
from pydantic import BaseModel
from sqlalchemy import select

from app.crud.base import CRUDBase
from app.models.redirect import Redirect
from app.models.senior.senior_student import SeniorStudent
from app.schemas.redirect import RedirectCreate
from app.schemas.senior.senior_student import SeniorStudentCreate
from app.tests.conftest import SessionTesting


class _AliasOnly(BaseModel):
    alias: str


redirects = CRUDBase[Redirect, RedirectCreate, _AliasOnly](Redirect)


def _seed(db: SessionTesting, aliases: list[str]) -> None:
    for alias in aliases:
        redirects.create(db, obj_in=RedirectCreate(alias=alias, redirect="/x"))


def test_get_multi_returns_every_row(db: SessionTesting) -> None:
    _seed(db, ["a", "b", "c"])

    rows = redirects.get_multi(db)

    assert sorted(r.alias for r in rows) == ["a", "b", "c"]


def test_get_multi_applies_skip_and_limit(db: SessionTesting) -> None:
    _seed(db, ["a", "b", "c"])

    rows = redirects.get_multi(db, skip=1, limit=1)

    assert len(rows) == 1


def test_update_locked_updates_only_the_targeted_row(db: SessionTesting) -> None:
    _seed(db, ["keep", "change"])
    target = db.scalars(select(Redirect).where(Redirect.alias == "change")).one()

    updated = redirects.update_locked(db, id=target.id, obj_in=_AliasOnly(alias="changed"))

    assert updated is not None and updated.alias == "changed"
    assert db.scalars(select(Redirect).where(Redirect.alias == "keep")).one()


def test_update_locked_without_changes_returns_the_row(db: SessionTesting) -> None:
    _seed(db, ["only"])
    target = db.scalars(select(Redirect)).one()

    same = redirects.update_locked(db, id=target.id, obj_in=_AliasOnly.model_construct())

    assert same is not None and same.id == target.id


def test_update_locked_without_changes_locks_the_row(db: SessionTesting, monkeypatch) -> None:
    _seed(db, ["only"])
    target = db.scalars(select(Redirect)).one()
    executed: list[str] = []
    original_execute = db.execute

    def spy(stmt, *args, **kwargs):
        executed.append(str(stmt))
        return original_execute(stmt, *args, **kwargs)

    monkeypatch.setattr(db, "execute", spy)

    redirects.update_locked(db, id=target.id, obj_in=_AliasOnly.model_construct())

    assert any("FOR UPDATE" in sql for sql in executed)


def test_unmapped_foreign_key_violation_is_a_client_error(db: SessionTesting) -> None:
    students = CRUDBase[SeniorStudent, SeniorStudentCreate, BaseModel](SeniorStudent)

    with pytest.raises(HTTPException) as exc:
        students.create(
            db, obj_in=SeniorStudentCreate(user_id=-1, senior_id=-1, image="i.jpg")
        )

    assert exc.value.status_code == 400


def test_create_flushes_but_does_not_commit(db: SessionTesting, monkeypatch) -> None:
    def unexpected_commit() -> None:
        pytest.fail("CRUD must not own the request transaction")

    monkeypatch.setattr(db, "commit", unexpected_commit)
    created = redirects.create(
        db, obj_in=RedirectCreate(alias="no-commit", redirect="/target")
    )
    assert created.id is not None


def test_failed_second_operation_rolls_back_first(connection) -> None:
    """A request owner can roll back all earlier CRUD work after B fails."""
    from app.tests.conftest import SessionTesting

    session = SessionTesting(bind=connection)
    try:
        redirects.create(
            session, obj_in=RedirectCreate(alias="atomic", redirect="/first")
        )
        students = CRUDBase[SeniorStudent, SeniorStudentCreate, BaseModel](SeniorStudent)
        with pytest.raises(HTTPException):
            students.create(
                session,
                obj_in=SeniorStudentCreate(user_id=-1, senior_id=-1, image="i.jpg"),
            )
        session.rollback()
        assert session.scalar(
            select(Redirect).where(Redirect.alias == "atomic")
        ) is None
    finally:
        session.close()


class _TeamMemberIn(BaseModel):
    section_id: int
    name: str
    role: str


def _section_id(db: SessionTesting) -> int:
    from app.models.team.team_mandate import TeamMandate
    from app.models.team.team_section import TeamSection

    mandate = TeamMandate(mandate="2099/00")
    db.add(mandate)
    db.flush()
    section = TeamSection(mandate_id=mandate.id, name="Coordenação", weight=0)
    db.add(section)
    db.flush()
    return section.id


def test_check_violation_becomes_400_not_500(db: SessionTesting) -> None:
    """Directus and the API both hit CHECK constraints; a 500 helps nobody."""
    from app.models.team.team_member import TeamMember

    members = CRUDBase[TeamMember, _TeamMemberIn, _TeamMemberIn](TeamMember)

    with pytest.raises(HTTPException) as exc:
        members.create(
            db,
            obj_in=_TeamMemberIn(section_id=_section_id(db), name="   ", role="Vogal"),
        )

    assert exc.value.status_code == 400


def test_check_violation_uses_the_mapped_message(db: SessionTesting) -> None:
    from app.models.team.team_member import TeamMember

    class _Mapped(CRUDBase[TeamMember, _TeamMemberIn, _TeamMemberIn]):
        _check_violation_msgs = {"ck_team_member_name_not_blank": "Name is required"}

    with pytest.raises(HTTPException) as exc:
        _Mapped(TeamMember).create(
            db,
            obj_in=_TeamMemberIn(section_id=_section_id(db), name="   ", role="Vogal"),
        )

    assert exc.value.detail == "Name is required"


class _PermissiveRgm(BaseModel):
    """Omits mandate_id, which is NOT NULL: mimics a write that bypasses the schema."""

    category: str
    title: str


def test_unclassified_integrity_error_is_not_a_500(db: SessionTesting) -> None:
    from app import crud

    with pytest.raises(HTTPException) as exc:
        crud.rgm.create(db, obj_in=_PermissiveRgm(category="ATA", title="x"))

    assert exc.value.status_code == 400


def test_team_member_blank_name_reports_the_mapped_message(db: SessionTesting) -> None:
    """Directus writes bypass Pydantic, so the CHECK is still the real guard."""
    from app import crud

    with pytest.raises(HTTPException) as exc:
        crud.team_member.create(
            db,
            obj_in=_TeamMemberIn(section_id=_section_id(db), name="   ", role="Vogal"),
        )

    assert exc.value.detail == "Name cannot be blank!"


class _PermissiveFainaMember(BaseModel):
    faina_id: int
    role_id: int


def test_faina_member_identity_reports_the_mapped_message(db: SessionTesting) -> None:
    from app import crud
    from app.models.faina.faina import Faina
    from app.models.faina.faina_role import FainaRole

    db.add(Faina(id=1, mandate="2099"))
    db.add(FainaRole(id=1, name="Vogal", weight=0))
    db.flush()

    with pytest.raises(HTTPException) as exc:
        crud.faina_member.create(db, obj_in=_PermissiveFainaMember(faina_id=1, role_id=1))

    assert "name" in exc.value.detail.lower()
