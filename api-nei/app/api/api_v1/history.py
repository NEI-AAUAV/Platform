from fastapi import APIRouter, Depends
from typing import Annotated, Any, List

from app import crud
from app.api import deps
from app.schemas.history import HistoryCreate, HistoryUpdate, HistoryInDB

router = APIRouter()


@router.get("/", status_code=200, response_model=List[HistoryInDB])
def get(
    *,
    db: deps.DbSession,
    _: Annotated[Any, Depends(deps.cms_cache)],
) -> Any:
    return crud.history.get_multi(db=db)
