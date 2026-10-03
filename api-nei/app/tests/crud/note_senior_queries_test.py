"""Filtering/faceting rules of `crud.note` and the lookups of `crud.senior`."""

from datetime import datetime

import pytest
from sqlalchemy.orm import Session

from app import crud
from app.models import Note, Subject, Teacher, User
from app.models.senior.senior import Senior

WHEN = datetime(2022, 1, 1)


@pytest.fixture
def world(db: Session) -> dict:
    """2 users, 2 teachers, 2 subjects (years 1 and 2) and 4 notes."""
    ana = User(name="Ana", surname="A", created_at=WHEN, updated_at=WHEN)
    rui = User(name="Rui", surname="R", created_at=WHEN, updated_at=WHEN)
    t1, t2 = Teacher(name="T1"), Teacher(name="T2")
    s1 = Subject(code=7001, name="Calc", short="C", curricular_year=1, public=True)
    s2 = Subject(code=7002, name="Prog", short="P", curricular_year=2, public=True)
    db.add_all([ana, rui, t1, t2, s1, s2])
    db.flush()

    def note(name, author, subject, teacher, year, **flags):
        n = Note(
            name=name, author_id=author.id, subject_id=subject.code,
            teacher_id=teacher.id, year=year, created_at=WHEN, **flags,
        )
        db.add(n)
        return n

    notes = {
        "a": note("a", ana, s1, t1, 2020, summary=1),
        "b": note("b", ana, s2, t2, 2021, tests=1),
        "c": note("c", rui, s1, t2, 2021, summary=1, tests=1),
        "d": note("d", rui, s2, t1, None, slides=1),
    }
    db.commit()
    return dict(ana=ana, rui=rui, t1=t1, t2=t2, s1=s1, s2=s2, notes=notes)


def _names(rows) -> set[str]:
    return {n.name for n in rows}


def _page(db, **kw):
    kw.setdefault("categories", [])
    kw.setdefault("page", 1)
    kw.setdefault("size", 50)
    return crud.note.get_note_by(db=db, **kw)


# ------------------------------------------------------------- get_note_by


def test_no_filters_returns_everything_with_total(db, world) -> None:
    total, rows = _page(db)

    assert total == 4
    assert _names(rows) >= {"a", "b", "c", "d"}


@pytest.mark.parametrize(
    "filters,expected",
    [
        ({"year": 2021}, {"b", "c"}),
        ({"subject": 7001}, {"a", "c"}),
        ({"curricular_year": 2}, {"b", "d"}),
        ({"year": 2021, "subject": 7001}, {"c"}),
    ],
)
def test_filters_are_combined_with_and(db, world, filters, expected) -> None:
    total, rows = _page(db, **filters)

    assert _names(rows) == expected
    assert total == len(expected)


def test_student_and_teacher_filters(db, world) -> None:
    _, by_student = _page(db, student=world["ana"].id)
    _, by_teacher = _page(db, teacher=world["t1"].id)
    _, both = _page(db, student=world["rui"].id, teacher=world["t1"].id)

    assert _names(by_student) == {"a", "b"}
    assert _names(by_teacher) == {"a", "d"}
    assert _names(both) == {"d"}


def test_categories_are_or_combined(db, world) -> None:
    _, rows = _page(db, categories=["summary", "slides"])

    assert _names(rows) == {"a", "c", "d"}


def test_categories_combine_with_other_filters(db, world) -> None:
    _, rows = _page(db, categories=["tests"], year=2021, subject=7001)

    assert _names(rows) == {"c"}


def test_pagination_reports_full_total_but_slices_rows(db, world) -> None:
    total, first = _page(db, page=1, size=3)
    _, second = _page(db, page=2, size=3)

    assert total == 4
    assert len(first) == 3 and len(second) == 1
    assert _names(first).isdisjoint(_names(second))


def test_unmatched_filter_returns_empty(db, world) -> None:
    assert _page(db, year=1999) == (0, [])


# ----------------------------------------------------------------- facets


def test_facet_students_respect_other_filters(db, world) -> None:
    rows = crud.note.get_note_students(db, 2021, None, None, None)
    narrowed = crud.note.get_note_students(db, None, 7001, None, None)

    assert {u.id for u in rows} == {world["ana"].id, world["rui"].id}
    assert {u.id for u in narrowed} == {world["ana"].id, world["rui"].id}
    only_t1 = crud.note.get_note_students(db, None, None, world["t1"].id, None)
    assert {u.id for u in only_t1} == {world["ana"].id, world["rui"].id}
    y1 = crud.note.get_note_students(db, 2020, None, None, None)
    assert {u.id for u in y1} == {world["ana"].id}


def test_facet_teachers(db, world) -> None:
    for_ana = crud.note.get_note_teachers(db, None, None, world["ana"].id, None)
    in_2020 = crud.note.get_note_teachers(db, 2020, None, None, None)

    assert {t.id for t in for_ana} == {world["t1"].id, world["t2"].id}
    assert {t.id for t in in_2020} == {world["t1"].id}


def test_facet_subjects(db, world) -> None:
    for_t2 = crud.note.get_note_subjects(db, None, world["t2"].id, None, None)
    in_year_2 = crud.note.get_note_subjects(db, None, None, None, 2)

    assert {s.code for s in for_t2} == {7001, 7002}
    assert {s.code for s in in_year_2} == {7002}


def test_facet_years_ignore_notes_without_year(db, world) -> None:
    years = crud.note.get_note_years(db, None, None, None, None)

    assert sorted(years) == [2020, 2021]
    assert sorted(crud.note.get_note_years(db, 7001, None, None, None)) == [2020, 2021]


def test_facet_curricular_years(db, world) -> None:
    everything = crud.note.get_note_curricular_year(db, None, None, None, None)
    for_ana = crud.note.get_note_curricular_year(db, None, None, world["ana"].id, 7001)

    assert sorted(everything) == [1, 2]
    assert for_ana == [1]


# ------------------------------------------------------------------ senior


def _seniors(db: Session) -> None:
    db.add_all(
        [
            Senior(year=2020, course="LEI"),
            Senior(year=2021, course="LEI"),
            Senior(year=2021, course="MI"),
        ]
    )
    db.commit()


def test_senior_courses_are_distinct(db) -> None:
    _seniors(db)

    assert sorted(crud.senior.get_course(db)) == ["LEI", "MI"]


def test_senior_years_for_course(db) -> None:
    _seniors(db)

    assert sorted(crud.senior.get_course_year(db, course="LEI")) == [2020, 2021]
    assert crud.senior.get_course_year(db, course="MI") == [2021]
    assert crud.senior.get_course_year(db, course="XX") == []


def test_senior_get_by_year_and_course(db) -> None:
    _seniors(db)

    found = crud.senior.get_by(db, year=2021, course="MI")

    assert (found.year, found.course) == (2021, "MI")
    assert crud.senior.get_by(db, year=2099, course="MI") is None
