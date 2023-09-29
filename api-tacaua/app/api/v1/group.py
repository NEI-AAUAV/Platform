from fastapi import APIRouter, Depends, HTTPException, Security
from sqlalchemy.orm import Session
from typing import Any, Optional

from app import crud
from app.api import auth, deps
from app.core.logging import logger
from app.schemas.group import Group, GroupCreate, GroupUpdate
from app.schemas.standings import StandingGroupTeam, StandingsCreate

router = APIRouter()

responses = {
    404: {'description': "Group Not Found"},
}


@router.post("/", status_code=201, response_model=Group)
async def create_group(
    group_in: GroupCreate,
    db: Session = Depends(deps.get_db),
    _=Security(auth.verify_scopes, scopes=[auth.ScopeEnum.MANAGER_TACAUA]),
) -> Any:
    return crud.group.create(db, obj_in=group_in)


@router.put("/{id}", status_code=200, response_model=Group,
            responses={404: {'description': "Group Not Found / "
                             "Exchange Group Not Found / "
                             "Team In Modality Not Found"}})
async def update_group(
    id: int,
    group_in: GroupUpdate,
    db: Session = Depends(deps.get_db),
    _=Security(auth.verify_scopes, scopes=[auth.ScopeEnum.MANAGER_TACAUA]),
) -> Any:
    return crud.group.update(db, id=id, obj_in=group_in)


@router.delete("/{id}", status_code=200, response_model=Group,
               responses=responses)
def remove_group(
    id: int, db: Session = Depends(deps.get_db),
    _=Security(auth.verify_scopes, scopes=[auth.ScopeEnum.MANAGER_TACAUA]),
) -> Any:
    return crud.group.remove(db, id=id)

@router.post("/{group_id}/teams/", status_code=201, response_model=Group)
def add_team_to_group(
    group_id: int,
    standing_group_team: StandingGroupTeam,
    db: Session = Depends(deps.get_db),
) -> Any:

    group = crud.group.get(db=db, id=group_id)
    if not group:
        raise HTTPException(status_code=404, detail="Group not found.")

    team = crud.team.get(db=db, id=standing_group_team.team_id)
    if not team:
        raise HTTPException(status_code=404, detail="Team not found.")

    competition = crud.competition.get(db=db, id=group.competition_id)
    if not competition:
        raise HTTPException(status_code=404, detail="Competition not found.")
    
    if team.modality_id != competition.modality_id:
        raise HTTPException(
            status_code=400,
            detail="Team does not belong to the modality of the group."
        )
    
    group = crud.group.update_teams(db=db, db_obj=group, teams_id={standing_group_team.team_id})

    standing = crud.standings.get(db=db, team_id=team.id)
    
    if standing:
        # Create or update the standings for the added team
        standings_data = StandingsCreate(
            group_id=group_id,
            team_id=standing_group_team.team_id,
        )
        standing = crud.standings.create(db=db, obj_in=standings_data)

    # return group to update frontend
    return group