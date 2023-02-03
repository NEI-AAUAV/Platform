from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from typing import Any, List, Optional

from app import crud
from app.api import deps
from app.models.note import Note
from app.schemas import (NoteInDB,
                         NoteThankInDB,
                         NoteSchoolyearInDB,
                         NoteSubjectInDB,
                         NoteTeacherInDB,
                         NoteTypeInDB,
                         UserInDB)
from app.schemas.note import note_categories
from app.schemas.pagination import Page, PageParams


router = APIRouter()


@router.get("/thank", status_code=200, response_model=List[NoteThankInDB])
def get_note_thanks(
    *, db: Session = Depends(deps.get_db),
) -> Any:
    """Get all users we are thankful for."""

    return crud.note_thank.get_multi(db=db)


@router.get("/subject", status_code=200, response_model=List[NoteSubjectInDB])
def get_note_subjects(
    *, db: Session = Depends(deps.get_db),
    school_year: Optional[int] = None,
    student: Optional[int] = None,
    teacher: Optional[int] = None,
) -> Any:
    """
    Get all subjects that are associated with a `school_year`, `student` and `teacher`.
    """
    return crud.note_subject.get_multi(db=db)


@router.get("/teacher", status_code=200, response_model=List[NoteTeacherInDB])
def get_note_teachers(
    *, db: Session = Depends(deps.get_db),
    school_year: Optional[int] = None,
    subject: Optional[int] = None,
    student: Optional[int] = None,
) -> Any:
    """
    Get all teachers that are associated with a
    `school_year`, `subject` and `student`.
    """
    return crud.note_teacher.get_multi(db=db)


@router.get("/type", status_code=200, response_model=List[NoteTypeInDB])
def get_note_types(
    *, db: Session = Depends(deps.get_db),
) -> Any:
    return crud.note_type.get_multi(db=db)


@router.get("/year", status_code=200, response_model=List[NoteSchoolyearInDB])
def get_note_year(
    *, db: Session = Depends(deps.get_db),
    subject: Optional[int] = None,
    student: Optional[int] = None,
    teacher: Optional[int] = None,
) -> Any:
    """
    Get all years that are associated with a
    `subject`, `student` and `teacher`.
    """
    return crud.note_schoolyear.get_multi(db=db)


@router.get("/student", status_code=200, response_model=List[UserInDB])
def get_note_students(
    *, db: Session = Depends(deps.get_db),
    school_year: Optional[int] = None,
    subject: Optional[int] = None,
    teacher: Optional[int] = None,
) -> Any:
    """
    Get all students that are associated with a
    `school_year`, `subject` and `teacher`.
    """
    return crud.note.get_note_students(db=db)


@router.get("/", status_code=200, response_model=Page[NoteInDB])
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
    if not note_categories.issuperset(categories):
        raise HTTPException(status_code=400, detail="Invalid category")

    categories = categories or note_categories

    total, items = crud.note.get_note_by(
        db=db, categories=categories,
        school_year=school_year,
        subject=subject,
        student=student,
        teacher=teacher,
        page=page_params.page, size=page_params.size)
    return Page.create(total, items, page_params)


@router.get("/{id}", status_code=200, response_model=NoteInDB)
def get_note_by_id(
    *, id: int, db: Session = Depends(deps.get_db),
) -> Any:
    if not db.get(Note, id):
        raise HTTPException(status_code=404, detail="Invalid Note id")
    return crud.note.get(db=db, id=id)
