"""Business rules of the course collection."""

import pytest
from pymongo.errors import DuplicateKeyError

from app.crud.crud_course import course as crud
from app.schemas.course import CourseCreate, CourseUpdate, DegreeType
from app.tests.factories import make_course


def _new(short: str = "LEI", degree: DegreeType = DegreeType.LICENCIATURA, **kw) -> CourseCreate:
    return CourseCreate(short=short, name=f"Name {short}", degree=degree, **kw)


def test_create_assigns_sequential_ids_and_stores_degree_as_plain_string() -> None:
    first = crud.create(obj_in=_new("LEI"))
    second = crud.create(obj_in=_new("MEI", DegreeType.MESTRADO))

    assert (first["_id"], second["_id"]) == (1, 2)
    assert first["degree"] == "Licenciatura" and type(first["degree"]) is str
    assert first["show"] is False


def test_short_code_is_unique_at_database_level() -> None:
    crud.create(obj_in=_new("LEI"))

    with pytest.raises(DuplicateKeyError):
        crud.create(obj_in=_new("LEI"))


def test_get_and_get_by_short() -> None:
    created = crud.create(obj_in=_new("LEI"))

    assert crud.get(created["_id"])["short"] == "LEI"
    assert crud.get_by_short("LEI")["_id"] == created["_id"]
    assert crud.get(999) is None
    assert crud.get_by_short("NOPE") is None


def test_listing_is_sorted_by_degree_then_short() -> None:
    make_course(1, "MEI", degree="Mestrado")
    make_course(2, "LEI", degree="Licenciatura")
    make_course(3, "LECI", degree="Licenciatura")

    assert [c["short"] for c in crud.get_multi()] == ["LECI", "LEI", "MEI"]


def test_listing_filters_by_degree_and_visibility() -> None:
    make_course(1, "LEI", degree="Licenciatura", show=True)
    make_course(2, "LECI", degree="Licenciatura", show=False)
    make_course(3, "MEI", degree="Mestrado", show=True)

    assert [c["short"] for c in crud.get_multi(degree="Mestrado")] == ["MEI"]
    assert {c["short"] for c in crud.get_multi(show_only=True)} == {"LEI", "MEI"}
    assert [c["short"] for c in crud.get_multi(degree="Licenciatura", show_only=True)] == ["LEI"]


def test_listing_paginates() -> None:
    for i, short in enumerate(["A", "B", "C", "D"], start=1):
        make_course(i, short)

    assert [c["short"] for c in crud.get_multi(skip=1, limit=2)] == ["B", "C"]
    assert crud.get_multi(skip=10) == []


def test_count_respects_query() -> None:
    make_course(1, "A", show=True)
    make_course(2, "B")

    assert crud.count() == 2
    assert crud.count({"show": True}) == 1


def test_update_changes_only_given_fields_and_converts_enum() -> None:
    created = crud.create(obj_in=_new("LEI"))

    updated = crud.update(id=created["_id"], obj_in=CourseUpdate(degree=DegreeType.MESTRADO))

    assert updated["degree"] == "Mestrado" and type(updated["degree"]) is str
    assert (updated["short"], updated["name"]) == ("LEI", "Name LEI")


def test_empty_update_returns_course_untouched() -> None:
    created = crud.create(obj_in=_new("LEI"))

    assert crud.update(id=created["_id"], obj_in=CourseUpdate()) == created


def test_update_unknown_course_returns_none() -> None:
    assert crud.update(id=404, obj_in=CourseUpdate(name="x")) is None


def test_update_to_taken_short_raises_duplicate() -> None:
    crud.create(obj_in=_new("LEI"))
    other = crud.create(obj_in=_new("MEI"))

    with pytest.raises(DuplicateKeyError):
        crud.update(id=other["_id"], obj_in=CourseUpdate(short="LEI"))


def test_delete_reports_whether_something_was_removed() -> None:
    created = crud.create(obj_in=_new("LEI"))

    assert crud.delete(id=created["_id"]) is True
    assert crud.delete(id=created["_id"]) is False
    assert crud.exists(created["_id"]) is False


def test_short_exists_can_exclude_the_course_being_edited() -> None:
    created = crud.create(obj_in=_new("LEI"))

    assert crud.short_exists("LEI") is True
    assert crud.short_exists("LEI", exclude_id=created["_id"]) is False
    assert crud.short_exists("XYZ") is False
