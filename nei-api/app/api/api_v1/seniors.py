import string
from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from typing import Any, List

from app import crud
from app.api import deps
from app.schemas import SeniorsCreate, SeniorsInDB, SeniorsUpdate
from app.models.seniors import Seniors

router = APIRouter()


@router.get("/", status_code=200, response_model=List[SeniorsInDB])
def get_seniors(
    *, db: Session = Depends(deps.get_db),
) -> Any:
    """
    Return seniors information.
    """
    return crud.seniors.get_multi(db=db)


@router.post("/", status_code=201, response_model=SeniorsInDB)
def create_seniors(
    *, seniors_create_in: SeniorsCreate, db: Session = Depends(deps.get_db)
) -> dict:
    """
    Create a new seniors row in the database.
    """
    seniors = crud.seniors.get(
        db=db, year=seniors_create_in.year, course=seniors_create_in.course)
    if (seniors):
        raise HTTPException(status_code=400, detail="Senior already exist!")
    return crud.seniors.create(db=db, obj_in=seniors_create_in)


@router.put("/", status_code=200, response_model=SeniorsInDB)
def update_seniors(
    *, seniors_update_in: SeniorsUpdate, db: Session = Depends(deps.get_db), year: int, course: str
) -> dict:
    """
    Update a seniors row in the database.
    """
    return crud.seniors.update(db=db, obj_in=seniors_update_in, db_obj=db.get(Seniors, (year, course)))


@router.get("/course", status_code=200, response_model=List[str])
def get_seniors_course(
    *, db: Session = Depends(deps.get_db),
) -> Any:
    return crud.seniors.get_course(db=db)


@router.get("/{course}/year", status_code=200, response_model=List[int])
def get_seniors_course_year(
    *, db: Session = Depends(deps.get_db),
    course: str
) -> Any:
    return crud.seniors.get_course_year(db=db, course=course)



@router.get("/{course}/{year}", status_code=200, response_model=SeniorsInDB)
def get_seniors_by(
    *, db: Session = Depends(deps.get_db),
    course: str, year: int,
) -> Any:
    """
    Return seniors information from a specific `course` and `year`.
    """
    return crud.seniors.get_by(db=db, course=course, year=year)
