from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from typing import Any, List, Optional

from app import crud
from app.api import deps
from app.models.notes import Notes
from app.models.notes_subject import NotesSubject
from app.models.notes_thanks import NotesThanks
from app.models.notes_teachers import NotesTeachers
from app.models.notes_types import NotesTypes
from app.models.notes_schoolyear import NotesSchoolYear
from app.schemas import NotesCreate, NotesUpdate, NotesInDB
from app.schemas import NotesThanksCreate, NotesThanksUpdate, NotesThanksInDB
from app.schemas import NotesSchoolyearCreate, NotesSchoolyearUpdate, NotesSchoolyearInDB
from app.schemas import NotesSubjectCreate, NotesSubjectUpdate, NotesSubjectInDB
from app.schemas import NotesTeachersCreate, NotesTeachersUpdate, NotesTeachersInDB
from app.schemas import NotesTypesCreate, NotesTypesUpdate, NotesTypesInDB
from app.schemas.pagination import Page, PageParams

router = APIRouter()


@router.get("/subjects", status_code=200, response_model=List[NotesSubjectInDB])
def get_notes_subject(
    *, db: Session = Depends(deps.get_db),
    school_year: Optional[int] = None,
    student: Optional[int] = None,
    teacher: Optional[int] = None,
) -> Any:
    """
    """
    return crud.notes_subject.get_multi(db=db)


@router.post("/subjects", status_code=201, response_model=NotesSubjectInDB)
def create_note_subject(
    *, subject_in: NotesSubjectCreate, db: Session = Depends(deps.get_db)
) -> dict:
    """
    Create a new note subject in the database.
    """
    return crud.notes_subject.create(db=db, obj_in=subject_in)


@router.put("/subjects/{paco_code}", status_code=200, response_model=NotesSubjectInDB)
def update_note_subject(
    *, note_in: NotesSubjectUpdate, db: Session = Depends(deps.get_db), paco_code: int
) -> dict:
    """
    Update a note in the database.
    """
    if not db.get(NotesSubject, paco_code):
        raise HTTPException(status_code=404, detail="Invalid Note Subject id")
    return crud.notes.update(db=db, obj_in=note_in, db_obj=db.get(NotesSubject, paco_code))


@router.get("/thanks", status_code=200, response_model=List[NotesThanksInDB])
def get_notes_thanks(
    *, db: Session = Depends(deps.get_db),
) -> Any:
    """Get all users we are thankful for."""

    return crud.notes_thanks.get_multi(db=db)


@router.post("/thanks", status_code=201, response_model=NotesThanksInDB)
def create_note_thank(
    *, note_thank_in: NotesThanksCreate, db: Session = Depends(deps.get_db)
) -> dict:
    """
    Create a new note thank in the database.
    """
    return crud.notes_thanks.create(db=db, obj_in=note_thank_in)


@router.put("/thanks/{note_thank_id}", status_code=200, response_model=NotesThanksInDB)
def update_note_thank(
    *, note_in: NotesThanksUpdate, db: Session = Depends(deps.get_db), note_thank_id: int
) -> dict:
    """
    Update a note thank in the database.
    """
    if not db.get(NotesThanks, note_thank_id):
        raise HTTPException(status_code=404, detail="Invalid Note Thanks id")
    return crud.notes_thanks.update(db=db, obj_in=note_in, db_obj=db.get(NotesThanks, note_thank_id))


@router.get("/teachers", status_code=200, response_model=List[NotesTeachersInDB])
def get_notes_teachers(
    *, db: Session = Depends(deps.get_db),
    school_year: Optional[int] = None,
    subject: Optional[int] = None,
    student: Optional[int] = None,
) -> Any:
    """
    Get all teachers that are associated with a `school_year`, `subject` and `student`.
    """
    return crud.notes_teachers.get_multi(db=db)


@router.post("/teachers", status_code=201, response_model=NotesTeachersInDB)
def create_note_teacher(
    *, note_teacher_in: NotesTeachersCreate, db: Session = Depends(deps.get_db)
) -> dict:
    """
    Create a new note teacher in the database.
    """
    return crud.notes_teachers.create(db=db, obj_in=note_teacher_in)


@router.put("/teachers/{note_teacher_id}", status_code=200, response_model=NotesTeachersInDB)
def update_note_teacher(
    *, note_in: NotesTeachersUpdate, db: Session = Depends(deps.get_db), note_teacher_id: int
) -> dict:
    """
    Update a note teacher in the database.
    """
    if not db.get(NotesTeachers, note_teacher_id):
        raise HTTPException(status_code=404, detail="Invalid Note Teachers id")
    return crud.notes_teachers.update(db=db, obj_in=note_in, db_obj=db.get(NotesTeachers, note_teacher_id))


@router.get("/types", status_code=200, response_model=List[NotesTypesInDB])
def get_notes_types(
    *, db: Session = Depends(deps.get_db),
) -> Any:
    """
    """
    return crud.notes_types.get_multi(db=db)


@router.post("/types", status_code=201, response_model=NotesTeachersInDB)
def create_note_type(
    *, note_types_in: NotesTypesCreate, db: Session = Depends(deps.get_db)
) -> dict:
    """
    Create a new note type in the database.
    """
    return crud.notes_types.create(db=db, obj_in=note_types_in)


@router.put("/types/{note_type_id}", status_code=200, response_model=NotesTypesInDB)
def update_note_type(
    *, note_in: NotesTypesUpdate, db: Session = Depends(deps.get_db), note_type_id: int
) -> dict:
    """
    Update a note type in the database.
    """
    if not db.get(NotesTypes, note_type_id):
        raise HTTPException(status_code=404, detail="Invalid Note Type id")
    return crud.notes_types.update(db=db, obj_in=note_in, db_obj=db.get(NotesTypes, note_type_id))


@router.get("/years", status_code=200, response_model=List[NotesSchoolyearInDB])
def get_notes_year(
    *, db: Session = Depends(deps.get_db),
    subject: Optional[int] = None,
    student: Optional[int] = None,
    teacher: Optional[int] = None,
) -> Any:
    """
    Get all years that are associated with a `subject`, `student` and `teacher`.
    """
    return crud.notes_schoolyear.get_multi(db=db)


@router.post("/years", status_code=201, response_model=NotesSchoolyearInDB)
def create_note_year(
    *, note_schoolyear_in: NotesSchoolyearCreate, db: Session = Depends(deps.get_db)
) -> dict:
    """
    Create a new note school year in the database.
    """
    return crud.notes_schoolyear.create(db=db, obj_in=note_schoolyear_in)


@router.put("/years/{note_year_id}", status_code=200, response_model=NotesSchoolyearInDB)
def update_note_year(
    *, note_in: NotesSchoolyearUpdate, db: Session = Depends(deps.get_db), note_year_id: int
) -> dict:
    """
    Update a note school year in the database.
    """
    if not db.get(NotesSchoolYear, note_year_id):
        raise HTTPException(status_code=404, detail="Invalid Note Year id")

    return crud.notes_schoolyear.update(db=db, obj_in=note_in, db_obj=db.get(NotesSchoolYear, note_year_id))


@router.get("/students", status_code=200, response_model=List[NotesSchoolyearInDB])
def get_notes_year(
    *, db: Session = Depends(deps.get_db),
    school_year: Optional[int] = None,
    subject: Optional[int] = None,
    teacher: Optional[int] = None,
) -> Any:
    """
    Get all students that are associated with a `school_year`, `subject` and `teacher`.
    """
    return crud.notes_schoolyear.get_multi(db=db)


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
    all_categories = {
        'summary', 'tests', 'bibliography', 'slides', 'exercises', 'projects', 'notebook'
    }

    if not all_categories.issuperset(categories):
        raise HTTPException(status_code=400, detail="Invalid category")

    items = crud.notes.get_notes_by_categories(db=db, categories=categories,
                                               page=page_params.page, size=page_params.size)
    return Page.create(items, page_params)


@router.get("/{note_id}", status_code=200, response_model=NotesInDB)
def get_note_by_id(
    *, note_id: int, db: Session = Depends(deps.get_db),
) -> Any:
    """
    """
    if not db.get(Notes, note_id):
        raise HTTPException(status_code=404, detail="Invalid Note id")
    return crud.notes.get(db=db, id=note_id)


@router.post("/", status_code=201, response_model=NotesInDB)
def create_note(
    *, note_in: NotesCreate, db: Session = Depends(deps.get_db)
) -> dict:
    """
    Create a new note in the database.
    """
    return crud.notes.create(db=db, obj_in=note_in)


@router.put("/{note_id}", status_code=200, response_model=NotesInDB)
def update_note(
    *, note_in: NotesUpdate, db: Session = Depends(deps.get_db), note_id: int
) -> dict:
    """
    Update a note in the database.
    """
    if not db.get(Notes, note_id):
        raise HTTPException(status_code=404, detail="Invalid Note id")
    return crud.notes.update(db=db, obj_in=note_in, db_obj=db.get(Notes, note_id))
