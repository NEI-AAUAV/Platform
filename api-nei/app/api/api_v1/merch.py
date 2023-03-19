from fastapi import APIRouter, Depends, HTTPException, Query, Response
from sqlalchemy.orm import Session
from typing import Any, List

from app import crud
from app.api import deps
from app.schemas.merch import MerchCreate, MerchUpdate, MerchInDB

router = APIRouter()


@router.get("/", status_code=200, response_model=List[MerchInDB])
def get(
    *, db: Session = Depends(deps.get_db), response : Response,
) -> Any:
    response.headers["cache-control"] = "private, max-age=15552000, no-cache"
    return crud.merch.get_multi(db=db)
