from fastapi import APIRouter, Depends, HTTPException, Security, UploadFile, File, Request, Form, List
from sqlalchemy.orm import Session
from typing import Any, Optional

from app import crud
from app.api import auth, deps
from app.core.logging import logger
from app.models.group import Group
from app.models.standings import Standings

router = APIRouter()




@router.post("/standings", status_code=200, response_model=List[Standings])
def create_group_standings(
    group_id = int,
    db: Session = Depends(deps.get_db),
    # _=Security(auth.verify_scopes, scopes=[auth.ScopeEnum.MANAGER_TACAUA]),
) -> Any:
    group = crud.group.get(db=db, id=group_id)
    if not group:
        raise HTTPException(status_code=404, detail="Group not found.")
    
    teams = group.teams

    list_standings = []

    for team in teams:
        standing = Standings(
            team=team.id,
            group=group.id
        )

        crud.standings.create(db, obj_in=standing)
        list_standings.append(standing)
    
    return list_standings


@router.get("/standings/{group_id}", status_code=200, response_model=(str, List[Standings]))
def get_group_standings(
    group_id = int,
    db: Session = Depends(deps.get_db)
) -> Any:
    group = crud.group.get(db=db, id=group_id)
    if not group:
        raise HTTPException(status_code=404, detail="Group not found.")
    
    standing = crud.standings.get(db=db, group_id=group.id)

    if not standing:
        return("auto", autoGenStanding())
        
    else:
        return ("already_in_db", standing)


@router.post("/groups/{group_id}/teams", status_code=201, response_model=Group)
def add_team_to_group(
    group_id: int,
    team_id: int,
    db: Session = Depends(deps.get_db),
) -> Any:
    
    group = crud.group.get(db=db, id=group_id)
    if not group:
        raise HTTPException(status_code=404, detail="Group not found.")

    team = crud.team.get(db=db, id=team_id)
    if not team:
        raise HTTPException(status_code=404, detail="Team not found.")

    if team.modality_id != group.competition_id.modality_id:
        raise HTTPException(
            status_code=400,
            detail="Team does not belong to the modality of the group."
        )

    

    crud.group.update_teams(db=db, db_obj=group, teams_id=[team_id])

    standing = crud.standings.get(db=db, team_id=team.id)
    
    if standing:
        # Create or update the standings for the added team
        standings_data = Standings(
            group_id=group_id,
            team_id=team_id,
            pts=0,
            matches=0,
            wins=0,
            ties=0,
            losses=0,
            ff=0,
            score_for=0,
            score_agst=0,
            math_history=[]
        )
        crud.standings.create(db=db, obj_in=standings_data)

    return standings_data

def autoGenStanding() -> List[Standings]:
    pass
    
