from typing import Annotated, List

from fastapi import APIRouter, Depends, HTTPException, Security
from pydantic import TypeAdapter
from sqlalchemy.orm import Session

from app import crud
from app.api import deps
from app.api.auth import AuthData, api_nei_auth
from app.exception import NotFoundException
from app.schemas.user import DetailedUser
from app.schemas.team import AdminCheckPointSelect, ListingTeam
from app.schemas.checkpoint import DetailedCheckPoint

from ._deps import get_checkpoint_id

router = APIRouter()


@router.get("/", status_code=200)
def get_checkpoints(*, db: Session = Depends(deps.get_db)) -> List[DetailedCheckPoint]:
    DetailedCheckPointListAdapter = TypeAdapter(List[DetailedCheckPoint])
    return DetailedCheckPointListAdapter.validate_python(
        crud.checkpoint.get_multi(db=db)
    )


@router.get("/me", status_code=200)
def get_next_checkpoint(
    *,
    db: Session = Depends(deps.get_db),
    curr_user: DetailedUser = Depends(deps.get_participant)
) -> DetailedCheckPoint:
    """Return the next checkpoint a team must head to."""
    if curr_user.team_id is None:
        raise HTTPException(status_code=409, detail="User doesn't belong to a team")

    checkpoint = crud.checkpoint.get_next(db=db, team_id=curr_user.team_id)

    if checkpoint is None:
        raise NotFoundException(detail="Checkpoint Not Found")

    return DetailedCheckPoint.model_validate(checkpoint)


@router.get("/teams", status_code=200)
def get_checkpoint_teams(
    *,
    db: Session = Depends(deps.get_db),
    select: Annotated[AdminCheckPointSelect, Depends()],
    auth: AuthData = Security(api_nei_auth, scopes=[]),
    admin_or_staff_user: DetailedUser = Depends(deps.get_admin_or_staff)
) -> List[ListingTeam]:
    """
    If a staff is authenticated, returned all teams that just passed
    through a staff's checkpoint.
    If an admin is authenticated, returned all teams.
    """
    if deps.is_admin(auth.scopes) and select.checkpoint_id is None:
        teams = crud.team.get_multi(db)
    else:
        checkpoint_id = get_checkpoint_id(admin_or_staff_user, select, auth.scopes)
        teams = crud.team.get_by_checkpoint(db=db, checkpoint_id=checkpoint_id)
    ListingTeamListAdapter = TypeAdapter(List[ListingTeam])
    return ListingTeamListAdapter.validate_python(teams)
