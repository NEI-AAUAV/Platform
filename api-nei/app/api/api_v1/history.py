from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from typing import Any, List

from app import crud
from app.api import deps
from app.schemas.history import HistoryCreate, HistoryUpdate, HistoryInDB

router = APIRouter()


@router.get("/", status_code=200, response_model=List[HistoryInDB])
def get(
    *, db: Session = Depends(deps.get_db),
    _ = Depends(deps.long_cache)
) -> Any:
    return crud.history.get_multi(db=db)
