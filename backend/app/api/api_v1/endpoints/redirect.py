from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from typing import Any, List

from app import crud
from app.api import deps
from app.schemas import RedirectUpdate, RedirectCreate, RedirectInDB

router = APIRouter()

@router.get("/", status_code=200, response_model=RedirectInDB)
def get_redirect(
    *, alias: str,
    db: Session = Depends(deps.get_db)
) -> Any:
    resp = crud.redirect.get_redirect(db=db, alias=alias)
    if resp == None:
        raise HTTPException(status_code=404, detail="Not found.")
    else:
        return resp
