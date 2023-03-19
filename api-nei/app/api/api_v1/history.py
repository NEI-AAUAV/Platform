from fastapi import APIRouter, Depends, HTTPException, Query, Response
from sqlalchemy.orm import Session
from typing import Any, List

from app import crud
from app.api import deps
from app.schemas.history import HistoryCreate, HistoryUpdate, HistoryInDB

router = APIRouter()


@router.get("/", status_code=200, response_model=List[HistoryInDB])
def get(
    *, db: Session = Depends(deps.get_db), response : Response,
) -> Any:
    response.headers["cache-control"] = "private, max-age=2592000, no-cache"
    return crud.history.get_multi(db=db)
