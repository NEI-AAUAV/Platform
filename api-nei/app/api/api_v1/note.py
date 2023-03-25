from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from typing import Any, List, Optional

from app import crud
from app.api import deps
from app.models.note import Note
from app.schemas import (NoteInDB,
                         SubjectInDB,
                         TeacherInDB,
                         UserInDB)
from app.schemas.note import note_categories
from app.schemas.pagination import Page, PageParams


router = APIRouter()


@router.get("/subject", status_code=200, response_model=List[SubjectInDB])
def get_subjects(
    *, db: Session = Depends(deps.get_db),
    year: Optional[int] = None,
    teacher: Optional[int] = None,
    student: Optional[int] = None,
    curricular_year: Optional[int] = None,
) -> Any:
    """
    Get all subjects that are associated with a `year`, `student` and `teacher`.
    """

    data = crud.note.get_note_subjects(
        db=db, year=year, teacher_id=teacher, student_id=student, curricular_year=curricular_year)

    return data


@router.get("/teacher", status_code=200, response_model=List[TeacherInDB])
def get_teachers(
    *, db: Session = Depends(deps.get_db),
    year: Optional[int] = None,
    subject: Optional[int] = None,
    student: Optional[int] = None,
    curricular_year: Optional[int] = None,

) -> Any:
    """
    Get all teachers that are associated with a
    `year`, `subject` and `student`.
    """
    # return crud.teacher.get_multi(db=db)
    data = crud.note.get_note_teachers(
        db=db, year=year, subject_code=subject, student_id=student, curricular_year=curricular_year)

    return data


# Retirado response_model=List[int] pq existe valor null
@router.get("/year", status_code=200)
def get_note_years(
    *, db: Session = Depends(deps.get_db),
    subject_id: Optional[int] = None,
    student_id: Optional[int] = None,
    teacher_id: Optional[int] = None,
    curricular_year: Optional[int] = None,
) -> Any:
    """
    Get all years that are associated with a
    `subject`, `student` and `teacher`.
    """
    return crud.note.get_note_years(db=db, subject_code=subject_id, student_id=student_id, teacher_id=teacher_id, curricular_year=curricular_year)


@router.get("/student", status_code=200, response_model=List[UserInDB])
def get_note_students(
    *, db: Session = Depends(deps.get_db),
    year: Optional[int] = None,
    subject: Optional[int] = None,
    teacher: Optional[int] = None,
    curricular_year: Optional[int] = None,
) -> Any:
    """
    Get all students that are associated with a
    `year`, `subject` and `teacher`.
    """
    # return crud.note.get_note_students(db=db)
    data = crud.note.get_note_students(
        db=db, year=year, subject_code=subject, teacher_id=teacher, curricular_year=curricular_year)

    return data

@router.get("/curricularyear", status_code=200)
def get_note_students(
    *, db: Session = Depends(deps.get_db),
    year: Optional[int] = None,
    subject: Optional[int] = None,
    teacher: Optional[int] = None,
    curricular_year: Optional[int] = None,
) -> Any:
    """
    Get all students that are associated with a
    `year`, `subject` and `teacher`.
    """
    # return crud.note.get_note_students(db=db)
    data = crud.note.get_note_students(db=db, year=year, subject_code=subject, teacher_id=teacher, curricular_year=curricular_year)
    
    return data 

@router.get("/", status_code=200, response_model=Page[NoteInDB])
def get_notes(
    *, page_params: PageParams = Depends(PageParams),
    categories: List[str] = Query(
        default=[], alias='category[]',
        description="List of categories",
    ),
    year: Optional[int] = None,
    subject: Optional[int] = None,
    student: Optional[int] = None,
    teacher: Optional[int] = None,
    curricular_year: Optional[int] = None,
    db: Session = Depends(deps.get_db),
) -> Any:
    if not note_categories.issuperset(categories):
        raise HTTPException(status_code=400, detail="Invalid category")

    categories = categories or note_categories

    total, items = crud.note.get_note_by(
        db=db, categories=categories,
        year=year,
        subject=subject,
        student=student,
        teacher=teacher,
        curricular_year=curricular_year,
        page=page_params.page, size=page_params.size)
    return Page.create(total, items, page_params)


@router.get("/{id}", status_code=200, response_model=NoteInDB)
def get_note_by_id(
    *, id: int, db: Session = Depends(deps.get_db),
) -> Any:
    if not db.get(Note, id):
        raise HTTPException(status_code=404, detail="Invalid Note id")
    return crud.note.get(db=db, id=id)
