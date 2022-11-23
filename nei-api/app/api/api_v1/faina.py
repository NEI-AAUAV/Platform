from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from typing import Any, List

from app import crud
from app.api import deps
from app.schemas import FainaCreate, FainaInDB, FainaUpdate
from app.models.faina import Faina

router = APIRouter()


@router.get("/", status_code=200, response_model=List[FainaInDB])
def get_faina(
    *, db: Session = Depends(deps.get_db),
) -> Any:
    """
    Return faina information.
    """
    return crud.faina.get_multi(db=db)


@router.post("/", status_code=201, response_model=FainaInDB)
def create_faina(
    *, faina_create_in: FainaCreate, db: Session = Depends(deps.get_db)
) -> dict:
    """
    Create a new faina row in the database.
    """
    return crud.faina.create(db=db, obj_in=faina_create_in)

@router.put("/{mandato}", status_code=200, response_model=FainaInDB)
def update_faina(
    *, faina_update_in: FainaUpdate, db: Session = Depends(deps.get_db), mandato: int
) -> dict:
    """
    Update a faina row in the database.
    """
    faina = crud.faina.get_faina(db=db, mandato=mandato)
    if not faina:
        raise HTTPException(status_code=404, detail="Faina Not Found")
    return crud.faina.update(db=db, obj_in=faina_update_in, db_obj=db.get(Faina, mandato))
