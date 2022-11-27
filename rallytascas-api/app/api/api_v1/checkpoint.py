from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from typing import Any

from app import crud
from app.api import deps
from app.exception import NotFoundException
from app.schemas.user import UserInDB
from app.schemas.checkpoint import CheckPointInDB


router = APIRouter()


@router.get("/me", status_code=200, response_model=CheckPointInDB)
def get_next_checkpoint(
    *, db: Session = Depends(deps.get_db),
    curr_user: UserInDB = Depends(deps.get_participant)
) -> Any:
    """Return the next checkpoint a team must head to."""

    checkpoint = crud.checkpoint.get_next(db=db, team_id=curr_user.team_id)
    if not checkpoint:
        raise NotFoundException(detail="Checkpoint Not Found")
    return checkpoint


@router.get("/teams", status_code=200, response_model=CheckPointInDB)
def get_checkpoint_teams(
    *, db: Session = Depends(deps.get_db),
    staff_user: UserInDB = Depends(deps.get_staff)
) -> Any:
    """Return all teams that are heading to a staff's checkpoint."""

    return crud.team.get_by_checkpoint(
        db=db, checkpoint_id=staff_user.staff_checkpoint_id)
