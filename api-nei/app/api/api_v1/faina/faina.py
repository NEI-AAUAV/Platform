from fastapi import APIRouter, Depends, HTTPException, Security
from sqlalchemy.orm import Session
from typing import Any, List

from app import crud
from app.api import deps
from app.api.api_v1 import auth
from app.schemas import FainaCreate, FainaInDB, FainaUpdate
from app.schemas.user.user import ScopeEnum

router = APIRouter()


@router.get("/", status_code=200, response_model=List[FainaInDB])
def get_faina(
    *,
    db: Session = Depends(deps.get_db),
    _=Depends(deps.long_cache),
) -> Any:
    """
    Return faina information.
    """
    return crud.faina.get_multi(db=db)


@router.post("/", status_code=201, response_model=FainaInDB)
def create_faina(
    *,
    faina_create_in: FainaCreate,
    db: Session = Depends(deps.get_db),
    _=Security(auth.verify_token, scopes=[ScopeEnum.MANAGER_NEI]),
) -> dict:
    """
    Create a new faina row in the database.
    """
    return crud.faina.create(db=db, obj_in=faina_create_in)


@router.put("/{id}", status_code=200, response_model=FainaInDB)
def update_faina(
    *,
    id: int,
    faina_update_in: FainaUpdate,
    db: Session = Depends(deps.get_db),
    _=Security(auth.verify_token, scopes=[ScopeEnum.MANAGER_NEI]),
) -> dict:
    """
    Update a faina row in the database.
    """
    faina = crud.faina.update_locked(db=db, id=id, obj_in=faina_update_in)
    if faina is None:
        raise HTTPException(status_code=404, detail="Faina Not Found")
    return faina
