from fastapi import APIRouter, Depends, HTTPException, Security
from sqlalchemy.orm import Session
from typing import Any, List

from app import crud
from app.api import deps
from app.api.api_v1 import auth
from app.schemas import SeniorStudentCreate, SeniorStudentInDB, SeniorStudentUpdate
from app.schemas.user.user import ScopeEnum

router = APIRouter()


@router.get("/", status_code=200, response_model=List[SeniorStudentInDB])
def get_senior_students(
    *,
    db: Session = Depends(deps.get_db),
    _=Depends(deps.long_cache),
) -> Any:
    """
    Return senior students information.
    """
    return crud.senior_student.get_multi(db=db)


@router.post("/", status_code=201, response_model=SeniorStudentInDB)
def create_senior_student(
    *,
    senior_student_create_in: SeniorStudentCreate,
    db: Session = Depends(deps.get_db),
    _=Security(auth.verify_token, scopes=[ScopeEnum.MANAGER_NEI]),
) -> dict:
    """
    Create a new senior students row in the database.
    """
    return crud.senior_student.create(db=db, obj_in=senior_student_create_in)


@router.put("/{senior_id}/{user_id}", status_code=200, response_model=SeniorStudentInDB)
def update_senior_student(
    *,
    senior_id: int,
    user_id: int,
    senior_student_update_in: SeniorStudentUpdate,
    db: Session = Depends(deps.get_db),
    _=Security(auth.verify_token, scopes=[ScopeEnum.MANAGER_NEI]),
) -> dict:
    """
    Update a senior students row in the database.
    """
    student = crud.senior_student.update_locked(
        db=db,
        id=(senior_id, user_id),
        obj_in=senior_student_update_in,
    )
    if student is None:
        raise HTTPException(status_code=404, detail="Senior student not found")
    return student
