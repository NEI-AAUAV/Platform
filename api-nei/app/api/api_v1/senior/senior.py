from fastapi import APIRouter, Depends, HTTPException, Security
from sqlalchemy.orm import Session
from typing import List

from app import crud
from app.api import deps
from app.api.api_v1 import auth
from app.schemas import SeniorCreate, SeniorInDB, SeniorUpdate
from app.schemas.user.user import ScopeEnum

router = APIRouter()


@router.get("/", status_code=200, response_model=List[SeniorInDB])
def get_seniors(
    *,
    db: Session = Depends(deps.get_db),
    _=Depends(deps.long_cache),
):
    """
    Return senior information.
    """
    return crud.senior.get_multi(db=db)


@router.post("/", status_code=201, response_model=SeniorInDB)
def create_senior(
    *,
    senior_create_in: SeniorCreate,
    db: Session = Depends(deps.get_db),
    _=Security(auth.verify_token, scopes=[ScopeEnum.MANAGER_NEI]),
):
    """
    Create a new senior row in the database.
    """
    return crud.senior.create(db=db, obj_in=senior_create_in)


@router.put("/{id}", status_code=200, response_model=SeniorInDB)
def update_senior(
    *,
    id: int,
    senior_update_in: SeniorUpdate,
    db: Session = Depends(deps.get_db),
    _=Security(auth.verify_token, scopes=[ScopeEnum.MANAGER_NEI]),
):
    """
    Update a senior row in the database.
    """
    senior = crud.senior.update_locked(db=db, id=id, obj_in=senior_update_in)
    if senior is None:
        raise HTTPException(status_code=404, detail="Senior not found")
    return senior


@router.get("/course", status_code=200, response_model=List[str])
def get_senior_courses(
    *,
    db: Session = Depends(deps.get_db),
    _=Depends(deps.long_cache),
):
    return crud.senior.get_course(db=db)


@router.get("/{course}/year", status_code=200, response_model=List[int])
def get_senior_course_years(
    *, db: Session = Depends(deps.get_db), _=Depends(deps.long_cache), course: str
):
    return crud.senior.get_course_year(db=db, course=course)


@router.get("/{course}/{year}", status_code=200, response_model=SeniorInDB)
def get_senior_by(
    *,
    db: Session = Depends(deps.get_db),
    _=Depends(deps.long_cache),
    course: str,
    year: int,
):
    """
    Return senior information from a specific `course` and `year`.
    """
    senior = crud.senior.get_by(db=db, course=course, year=year)
    if senior is None:
        raise HTTPException(status_code=404, detail="Senior not found")
    return senior
