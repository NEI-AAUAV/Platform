import string
from fastapi import APIRouter, Depends, HTTPException, Query, Response
from sqlalchemy.orm import Session
from typing import Any, List

from app import crud
from app.api import deps
from app.schemas import SeniorCreate, SeniorInDB, SeniorUpdate
from app.models.senior import Senior

router = APIRouter()


@router.get("/", status_code=200, response_model=List[SeniorInDB])
def get_seniors(
    *, db: Session = Depends(deps.get_db), response : Response,
) -> Any:
    """
    Return senior information.
    """
    response.headers["cache-control"] = "private, max-age=15552000, no-cache"
    return crud.senior.get_multi(db=db)


@router.post("/", status_code=201, response_model=SeniorInDB)
def create_senior(
    *, senior_create_in: SeniorCreate, db: Session = Depends(deps.get_db)
) -> dict:
    """
    Create a new senior row in the database.
    """
    senior = crud.senior.get(
        db=db, year=senior_create_in.year, course=senior_create_in.course)
    if senior:
        raise HTTPException(status_code=400, detail="Senior already exist!")
    return crud.senior.create(db=db, obj_in=senior_create_in)


@router.put("/", status_code=200, response_model=SeniorInDB)
def update_senior(
    *, senior_update_in: SeniorUpdate, db: Session = Depends(deps.get_db), year: int, course: str
) -> dict:
    """
    Update a senior row in the database.
    """
    return crud.senior.update(db=db, obj_in=senior_update_in, db_obj=db.get(Senior, (year, course.upper())))


@router.get("/course", status_code=200, response_model=List[str])
def get_senior_courses(
    *, db: Session = Depends(deps.get_db), response : Response,
) -> Any:
    response.headers["cache-control"] = "private, max-age=15552000, no-cache"
    return crud.senior.get_course(db=db)


@router.get("/{course}/year", status_code=200, response_model=List[int])
def get_senior_course_years(
    *, db: Session = Depends(deps.get_db), 
    response : Response,
    course: str
) -> Any:
    response.headers["cache-control"] = "private, max-age=15552000, no-cache"
    return crud.senior.get_course_year(db=db, course=course.upper())


@router.get("/{course}/{year}", status_code=200, response_model=SeniorInDB)
def get_senior_by(
    *, db: Session = Depends(deps.get_db), 
    response : Response,
    course: str, year: int,
) -> Any:
    """
    Return senior information from a specific `course` and `year`.
    """
    response.headers["cache-control"] = "private, max-age=15552000, no-cache"
    return crud.senior.get_by(db=db, course=course.upper(), year=year)
