from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from typing import Any, List

from app import crud
from app.api import deps
from app.schemas.partners import PartnersCreate, PartnersUpdate, PartnersInDB

router = APIRouter()


@router.get("/", status_code=200, response_model=List[PartnersInDB])
def get(
    *, db: Session = Depends(deps.get_db),
) -> Any:

    return crud.partners.get_multi(db=db)
