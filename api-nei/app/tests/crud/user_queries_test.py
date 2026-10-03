"""CRUDUser lookups, creation and email activation (needs the test database)."""
import pytest

from app.crud.crud_user import user as crud_user
from app.schemas.user import UserCreate
from app.tests.conftest import SessionTesting


def test_create_stores_user_with_its_email_inactive_by_default(db: SessionTesting) -> None:
    created = crud_user.create(db, obj_in=UserCreate(name="Ana", surname="Silva", email="ana@ua.pt"), active=False)

    found = crud_user.get_by_email(db, "ana@ua.pt")

    assert found is not None
    user, email = found
    assert user.id == created.id
    assert email.active is False


def test_create_can_mark_email_active(db: SessionTesting) -> None:
    crud_user.create(db, obj_in=UserCreate(name="Ana", surname="Silva", email="ana@ua.pt"), active=True)

    _, email = crud_user.get_by_email(db, "ana@ua.pt")

    assert email.active is True


def test_create_hashes_the_password(db: SessionTesting) -> None:
    from pydantic import SecretStr

    created = crud_user.create(
        db,
        obj_in=UserCreate(name="Ana", surname="Silva", email="ana@ua.pt", password=SecretStr("s3cret-pass")),
        active=True,
    )

    assert created.hashed_password
    assert "s3cret-pass" not in created.hashed_password


def test_create_without_password_leaves_hash_empty(db: SessionTesting) -> None:
    created = crud_user.create(db, obj_in=UserCreate(name="Ana", surname="Silva", email="ana@ua.pt"), active=True)

    assert created.hashed_password is None


def test_create_sets_timestamps(db: SessionTesting) -> None:
    created = crud_user.create(db, obj_in=UserCreate(name="Ana", surname="Silva", email="ana@ua.pt"), active=True)

    assert created.created_at is not None
    assert created.updated_at is not None


def test_get_by_email_returns_none_for_unknown_address(db: SessionTesting) -> None:
    assert crud_user.get_by_email(db, "nobody@ua.pt") is None


def test_get_email_fq_requires_matching_id_and_email(db: SessionTesting) -> None:
    ana = crud_user.create(db, obj_in=UserCreate(name="Ana", surname="Silva", email="ana@ua.pt"), active=True)
    rui = crud_user.create(db, obj_in=UserCreate(name="Rui", surname="Costa", email="rui@ua.pt"), active=True)

    assert crud_user.get_email_fq(db, id=ana.id, email="ana@ua.pt") is not None
    # right email, someone else's id: must not match
    assert crud_user.get_email_fq(db, id=rui.id, email="ana@ua.pt") is None


def test_activate_email_flips_flag_only_for_that_email(db: SessionTesting) -> None:
    ana = crud_user.create(db, obj_in=UserCreate(name="Ana", surname="Silva", email="ana@ua.pt"), active=False)

    result = crud_user.activate_email(db, user=ana, email="ana@ua.pt")

    assert result.active is True


def test_activate_unknown_email_fails(db: SessionTesting) -> None:
    ana = crud_user.create(db, obj_in=UserCreate(name="Ana", surname="Silva", email="ana@ua.pt"), active=False)

    with pytest.raises(AssertionError):
        crud_user.activate_email(db, user=ana, email="other@ua.pt")


def test_get_multi_with_emails_only_joins_active_emails(db: SessionTesting) -> None:
    crud_user.create(db, obj_in=UserCreate(name="Act", surname="X", email="act@ua.pt"), active=True)
    crud_user.create(db, obj_in=UserCreate(name="Pen", surname="X", email="pen@ua.pt"), active=False)

    rows = {u.name: e for u, e in crud_user.get_multi_with_emails(db)}

    assert rows["Act"] is not None
    assert rows["Act"].email == "act@ua.pt"
    assert rows["Pen"] is None  # user still listed, pending email not exposed


def test_update_bumps_updated_at_and_applies_only_set_fields(db: SessionTesting) -> None:
    from app.schemas.user import UserUpdate

    ana = crud_user.create(db, obj_in=UserCreate(name="Ana", surname="Silva", email="ana@ua.pt"), active=True)
    before = ana.updated_at

    updated = crud_user.update(db, db_obj=ana, obj_in=UserUpdate(name="Ana B"))

    assert updated.name == "Ana B"
    assert updated.updated_at >= before


def test_update_accepts_plain_dict(db: SessionTesting) -> None:
    ana = crud_user.create(db, obj_in=UserCreate(name="Ana", surname="Silva", email="ana@ua.pt"), active=True)

    updated = crud_user.update(db, db_obj=ana, obj_in={"name": "Zed"})

    assert updated.name == "Zed"
