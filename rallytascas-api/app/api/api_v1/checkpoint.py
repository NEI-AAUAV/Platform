from typing import Any, List

from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app import crud
from app.api import deps
from app.exception import NotFoundException
from app.schemas.user import UserInDB
from app.schemas.team import TeamMeInDB
from app.schemas.checkpoint import CheckPointInDB


router = APIRouter()


@router.get("/", status_code=200, response_model=List[CheckPointInDB])
def get_checkpoints(
    *, db: Session = Depends(deps.get_db)
) -> Any:
    return crud.checkpoint.get_multi(db=db)


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


@router.get("/teams", status_code=200, response_model=List[TeamMeInDB])
def get_checkpoint_teams(
    *, db: Session = Depends(deps.get_db),
    admin_or_staff_user: UserInDB = Depends(deps.get_admin_or_staff)
) -> Any:
    """
    If a staff is authenticated, returned all teams that just passed 
    through a staff's checkpoint.
    If an admin is authenticated, returned all teams.
    """
    if admin_or_staff_user.is_admin:
        return crud.team.get_multi(db)
    
    return crud.team.get_by_checkpoint(
        db=db, checkpoint_id=admin_or_staff_user.staff_checkpoint_id)
