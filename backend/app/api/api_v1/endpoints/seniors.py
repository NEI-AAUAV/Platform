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
    seniors = crud.seniors.get(db=db, year=seniors_create_in.year, course=seniors_create_in.course)
    if (seniors):
        raise HTTPException(status_code=400, detail="Senior already exist!")
    return crud.seniors.create(db=db, obj_in=seniors_create_in)

@router.put("/", status_code=200, response_model=SeniorsInDB)
def update_faina(
    *, seniors_update_in: SeniorsUpdate, db: Session = Depends(deps.get_db), year: int, course: str
) -> dict:
    """
    Update a seniors row in the database.
    """
    return crud.seniors.update(db=db, obj_in=seniors_update_in, db_obj=db.get(Seniors, (year, course)))
