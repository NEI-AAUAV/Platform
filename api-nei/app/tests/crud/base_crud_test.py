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
