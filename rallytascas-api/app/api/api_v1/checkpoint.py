from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from typing import Any

from app import crud
from app.api import deps
from app.schemas.user import UserInDB
from app.schemas.checkpoint import CheckPointInDB


router = APIRouter()


@router.get("/me", status_code=200, response_model=CheckPointInDB)
def get_next_checkpoint(
    *, db: Session = Depends(deps.get_db), curr_user: UserInDB = Depends(deps.get_current_active_user)
) -> Any:
    return crud.checkpoint.get_next(db=db, team_id=curr_user.team_id)
