"""User <-> role assignments: ObjectId handling, filters, joins and uniqueness."""

import pytest
from pymongo.errors import DuplicateKeyError

from app.crud.crud_userrole import user_role as crud
from app.schemas.userrole import UserRoleCreate, UserRoleUpdate
from app.tests.factories import make_role, make_user, make_user_role


def _new(user_id=1, role_id=".1.", year=20) -> UserRoleCreate:
    return UserRoleCreate(user_id=user_id, role_id=role_id, year=year)


def test_create_returns_document_with_string_id() -> None:
    created = crud.create(obj_in=_new())

    assert isinstance(created["_id"], str)
    assert len(created["_id"]) == 24
    assert (created["user_id"], created["role_id"], created["year"]) == (1, ".1.", 20)


def test_same_user_role_year_cannot_be_stored_twice() -> None:
    crud.create(obj_in=_new())

    duplicate = _new()

    with pytest.raises(DuplicateKeyError):
        crud.create(obj_in=duplicate)


def test_same_user_and_role_in_another_year_is_allowed() -> None:
    crud.create(obj_in=_new(year=20))
    crud.create(obj_in=_new(year=21))

    assert crud.count(user_id=1) == 2


@pytest.mark.parametrize("bad_id", ["", "123", "not-an-object-id", "z" * 24])
def test_malformed_ids_are_treated_as_not_found(bad_id: str) -> None:
    assert crud.get(bad_id) is None
    assert crud.update(id=bad_id, obj_in=UserRoleUpdate(year=1)) is None
    assert crud.delete(id=bad_id) is False


def test_get_returns_none_for_valid_but_unknown_id() -> None:
    assert crud.get("a" * 24) is None
    assert crud.update(id="a" * 24, obj_in=UserRoleUpdate(year=1)) is None
    assert crud.delete(id="a" * 24) is False


def test_lookup_helpers_filter_correctly() -> None:
    make_user_role(1, ".1.", 20)
    make_user_role(1, ".2.", 21)
    make_user_role(2, ".1.", 21)

    assert len(crud.get_by_user(1)) == 2
    assert len(crud.get_by_role(".1.")) == 2
    assert len(crud.get_by_year(21)) == 2
    assert crud.get_by_user(99) == []
    assert all(isinstance(d["_id"], str) for d in crud.get_by_user(1))


def test_get_multi_and_count_apply_the_same_filters() -> None:
    make_user_role(1, ".1.", 20)
    make_user_role(1, ".2.", 21)
    make_user_role(2, ".1.", 21)

    assert crud.count() == 3
    assert crud.count(user_id=1) == 2
    assert crud.count(role_id=".1.", year=21) == 1
    assert len(crud.get_multi(user_id=1)) == 2
    assert len(crud.get_multi(year=21, limit=1)) == 1
    assert len(crud.get_multi(skip=2)) == 1


def test_year_zero_is_a_real_filter_not_ignored() -> None:
    make_user_role(1, ".1.", 0)
    make_user_role(1, ".2.", 5)

    assert crud.count(year=0) == 1
    assert len(crud.get_multi(year=0)) == 1


def test_update_year_and_noop_update() -> None:
    doc_id = make_user_role(1, ".1.", 20)

    assert crud.update(id=doc_id, obj_in=UserRoleUpdate(year=22))["year"] == 22
    assert crud.update(id=doc_id, obj_in=UserRoleUpdate())["year"] == 22


def test_delete_and_delete_by_user() -> None:
    first = make_user_role(1, ".1.", 20)
    make_user_role(1, ".2.", 20)
    make_user_role(2, ".1.", 20)

    assert crud.delete(id=first) is True
    assert crud.delete_by_user(1) == 1
    assert crud.count() == 1


def test_exists_matches_the_full_triplet() -> None:
    make_user_role(1, ".1.", 20)

    assert crud.exists(1, ".1.", 20) is True
    assert crud.exists(1, ".1.", 21) is False
    assert crud.exists(1, ".2.", 20) is False


def test_details_join_user_and_role_information() -> None:
    make_user(1, "Ana Silva", sex="F", image="a.jpg", start_year=18)
    make_role(".1.", "Presidente", short="PRES", year_display_format="academic")
    make_user_role(1, ".1.", 20)

    items, total = crud.get_with_details(user_id=1)

    assert total == 1
    item = items[0]
    assert item["user_name"] == "Ana Silva"
    assert item["user"] == {
        "_id": 1, "name": "Ana Silva", "image": "a.jpg", "sex": "F", "start_year": 18,
    }
    assert (item["role_name"], item["role_short"], item["year_display_format"]) == (
        "Presidente", "PRES", "academic",
    )
    assert isinstance(item["_id"], str)


def test_details_without_matches_short_circuits() -> None:
    assert crud.get_with_details(user_id=1) == ([], 0)


def test_details_keep_assignments_whose_user_or_role_vanished() -> None:
    make_user_role(1, ".9.", 20)

    items, total = crud.get_with_details()

    assert total == 1
    assert items[0]["role_id"] == ".9."
    assert "role_name" not in items[0] or items[0]["role_name"] is None


def test_details_paginate_but_report_full_total() -> None:
    for year in (1, 2, 3):
        make_user_role(1, ".1.", year)

    items, total = crud.get_with_details(skip=1, limit=1)

    assert total == 3
    assert len(items) == 1
