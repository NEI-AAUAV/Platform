import string
from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from typing import Any, List

from app import crud
from app.api import deps
from app.schemas import SeniorsStudentsCreate, SeniorsStudentsInDB, SeniorsStudentsUpdate
from app.models.seniors_students import SeniorsStudents

router = APIRouter()


@router.get("/", status_code=200, response_model=List[SeniorsStudentsInDB])
def get_seniors_students(
    *, db: Session = Depends(deps.get_db),
) -> Any:
    """
    Return seniors students information.
    """
    return crud.seniors_students.get_multi(db=db)


@router.post("/", status_code=201, response_model=SeniorsStudentsInDB)
def create_seniors_students(
    *, seniors_students_create_in: SeniorsStudentsCreate, db: Session = Depends(deps.get_db)
) -> dict:
    """
    Create a new seniors students row in the database.
    """
    seniors = crud.seniors.get(db=db, year=seniors_students_create_in.year, course=seniors_students_create_in.course_name)
    if not seniors:
        raise HTTPException(status_code=404, detail="Senior not found")
    user = crud.users.get(db=db, id=seniors_students_create_in.user_id)
    if not user:
        raise HTTPException(status_code=400, detail="User not found!")
    return crud.seniors_students.create(db=db, obj_in=seniors_students_create_in)


@router.put("/", status_code=200, response_model=SeniorsStudentsInDB)
def update_seniors_students(
    *, seniors_students_update_in: SeniorsStudentsUpdate, db: Session = Depends(deps.get_db), year: int, course: str, user: int
) -> dict:
    """
    Update a seniors students row in the database.
    """
    return crud.seniors_students.update(db=db, obj_in=seniors_students_update_in, db_obj=db.get(SeniorsStudents, (year, course, user)))
