import string
from fastapi import APIRouter, Depends, HTTPException, Query, Response
from sqlalchemy.orm import Session
from typing import Any, List

from app import crud
from app.api import deps
from app.schemas import SeniorStudentCreate, SeniorStudentInDB, SeniorStudentUpdate
from app.models.senior import SeniorStudent

router = APIRouter()


@router.get("/", status_code=200, response_model=List[SeniorStudentInDB])
def get_senior_students(
    *, db: Session = Depends(deps.get_db),
    _ = Depends(deps.long_cache),
) -> Any:
    """
    Return senior students information.
    """
    return crud.senior_student.get_multi(db=db)


@router.post("/", status_code=201, response_model=SeniorStudentInDB)
def create_senior_student(
    *, senior_student_create_in: SeniorStudentCreate, db: Session = Depends(deps.get_db)
) -> dict:
    """
    Create a new senior students row in the database.
    """
    senior = crud.senior.get(db=db, year=senior_student_create_in.year, course=senior_student_create_in.course)
    if not senior:
        raise HTTPException(status_code=404, detail="Senior not found")
    user = crud.user.get(db=db, id=senior_student_create_in.user_id)
    if not user:
        raise HTTPException(status_code=400, detail="User not found!")
    return crud.senior_student.create(db=db, obj_in=senior_student_create_in)


@router.put("/", status_code=200, response_model=SeniorStudentInDB)
def update_senior_student(
    *, senior_student_update_in: SeniorStudentUpdate, db: Session = Depends(deps.get_db), year: int, course: str, user: int
) -> dict:
    """
    Update a senior students row in the database.
    """
    return crud.senior_student.update(db=db, obj_in=senior_student_update_in, db_obj=db.get(SeniorStudent, (year, course, user)))
