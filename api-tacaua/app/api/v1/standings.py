from fastapi import APIRouter, Depends, HTTPException, Security, UploadFile, File, Request, Form
from sqlalchemy.orm import Session
from typing import Any, Optional, List

from app import crud
from app.api import auth, deps
from app.core.logging import logger
from app.schemas.group import Group
from app.schemas.standings import StandingsInDB, StandingsCreate, StandingsTable

router = APIRouter()

@router.post("/{group_id}", status_code=201, response_model=StandingsTable)
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
        standing = StandingsCreate(
            team=team.id,
            group=group.id,
        )

        standing = crud.standings.create(db, obj_in=standing)
        list_standings.append(standing)
    
    return StandingsTable(auto=False, table=list_standings)


@router.get("/{group_id}", status_code=200, response_model=StandingsTable)
def get_group_standings(
    group_id = int,
    db: Session = Depends(deps.get_db)
) -> Any:
    group = crud.group.get(db=db, id=group_id)
    if not group:
        raise HTTPException(status_code=404, detail="Group not found.")
    
    standing = crud.standings.get_table(db=db, group_id=group.id)

    if not standing:
        return StandingsTable(auto=True, table=autoGenStanding())
        
    else:
        return StandingsTable(auto=False, table=standing)

def autoGenStanding() -> List[StandingsInDB]:
    return
    
