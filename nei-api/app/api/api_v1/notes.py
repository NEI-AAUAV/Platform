from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from typing import Any, List, Optional

from app import crud
from app.api import deps
from app.models.notes import Notes
from app.schemas import (NotesInDB,
                         NotesThanksInDB,
                         NotesSchoolyearInDB,
                         NotesSubjectInDB,
                         NotesTeachersInDB,
                         NotesTypesInDB,
                         UsersInDB)
from app.schemas.notes import notes_categories
from app.schemas.pagination import Page, PageParams


router = APIRouter()


@router.get("/thanks", status_code=200, response_model=List[NotesThanksInDB])
def get_notes_thanks(
    *, db: Session = Depends(deps.get_db),
) -> Any:
    """Get all users we are thankful for."""

    return crud.notes_thanks.get_multi(db=db)


@router.get("/subjects", status_code=200, response_model=List[NotesSubjectInDB])
def get_notes_subject(
    *, db: Session = Depends(deps.get_db),
    school_year: Optional[int] = None,
    student: Optional[int] = None,
    teacher: Optional[int] = None,
) -> Any:
    """
    Get all subjects that are associated with a `school_year`, `student` and `teacher`.
    """
    return crud.notes_subject.get_multi(db=db)


@router.get("/teachers", status_code=200, response_model=List[NotesTeachersInDB])
def get_notes_teachers(
    *, db: Session = Depends(deps.get_db),
    school_year: Optional[int] = None,
    subject: Optional[int] = None,
    student: Optional[int] = None,
) -> Any:
    """
    Get all teachers that are associated with a
    `school_year`, `subject` and `student`.
    """
    return crud.notes_teachers.get_multi(db=db)


@router.get("/types", status_code=200, response_model=List[NotesTypesInDB])
def get_notes_types(
    *, db: Session = Depends(deps.get_db),
) -> Any:
    return crud.notes_types.get_multi(db=db)


@router.get("/years", status_code=200, response_model=List[NotesSchoolyearInDB])
def get_notes_year(
    *, db: Session = Depends(deps.get_db),
    subject: Optional[int] = None,
    student: Optional[int] = None,
    teacher: Optional[int] = None,
) -> Any:
    """
    Get all years that are associated with a
    `subject`, `student` and `teacher`.
    """
    return crud.notes_schoolyear.get_multi(db=db)


@router.get("/students", status_code=200, response_model=List[UsersInDB])
def get_notes_students(
    *, db: Session = Depends(deps.get_db),
    school_year: Optional[int] = None,
    subject: Optional[int] = None,
    teacher: Optional[int] = None,
) -> Any:
    """
    Get all students that are associated with a
    `school_year`, `subject` and `teacher`.
    """
    return crud.notes.get_notes_students(db=db)


@router.get("/", status_code=200, response_model=Page[NotesInDB])
def get_notes(
    *, page_params: PageParams = Depends(PageParams),
    categories: List[str] = Query(
        default=[], alias='category[]',
        description="List of categories",
    ),
    school_year: Optional[int] = None,
    subject: Optional[int] = None,
    student: Optional[int] = None,
    teacher: Optional[int] = None,
    db: Session = Depends(deps.get_db),
) -> Any:
    if not notes_categories.issuperset(categories):
        raise HTTPException(status_code=400, detail="Invalid category")

    categories = categories or notes_categories

    total, items = crud.notes.get_notes_by_categories(
        db=db, categories=categories, page=page_params.page, size=page_params.size)
    return Page.create(total, items, page_params)


@router.get("/{id}", status_code=200, response_model=NotesInDB)
def get_note_by_id(
    *, id: int, db: Session = Depends(deps.get_db),
) -> Any:
    if not db.get(Notes, id):
        raise HTTPException(status_code=404, detail="Invalid Note id")
    return crud.notes.get(db=db, id=id)
