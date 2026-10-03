from fastapi import APIRouter, Depends, HTTPException, Query, Response
from sqlalchemy.orm import Session
from typing import Annotated, Any, List

from app import crud
from app.api import deps
from app.schemas.merch import MerchCreate, MerchUpdate, MerchInDB

router = APIRouter()


@router.get("/", status_code=200, response_model=List[MerchInDB])
def get(
    *,
    db: Annotated[Session, Depends(deps.get_db, scope="function")],
    _: Annotated[Any, Depends(deps.cms_cache)],
) -> Any:
    return crud.merch.get_by_discontinued(db=db, discontinued=False)
