from typing import Any, List

from fastapi import APIRouter, Depends, HTTPException, Query, Response
from sqlalchemy.orm import Session
from loguru import logger

from app import crud
from app.api import deps
from app.schemas import TeamMemberCreate, TeamMemberInDB, TeamMemberUpdate, TeamMandates
from app.models.team import TeamMember

router = APIRouter()


@router.get("/mandates", status_code=200, response_model=TeamMandates)
def get_team_members_mandates(
    db: Session = Depends(deps.get_db), 
    _ = Depends(deps.long_cache)
) -> Any:
    """
    Return all mandates.
    """
    data = crud.team_member.get_team_mandates(db=db)
    data = [e[0] for e in data]
    return {"data": data}


@router.get("/", status_code=200, response_model=List[TeamMemberInDB])
def get_team_members(
    mandate: str, 
    db: Session = Depends(deps.get_db), 
    _ = Depends(deps.long_cache)
) -> Any:
    return crud.team_member.get_team_by_mandate(db=db, mandate=mandate)


@router.post("/", status_code=201, response_model=TeamMemberInDB)
def create_team_member(
    *, team_create_in: TeamMemberCreate, db: Session = Depends(deps.get_db)
) -> dict:
    return crud.team_member.create(db=db, obj_in=team_create_in)


@router.put("/{id}", status_code=200, response_model=TeamMemberInDB)
def update_team_member(
    *, team_update_in: TeamMemberUpdate, db: Session = Depends(deps.get_db), id: int
) -> dict:
    """ testing, db.get(TeamMember, id) does not work
    obj = db.query(TeamMember).filter(TeamMember.user_id == id).first()
    print(obj.mandate)
    print(obj.user.name)
    print(obj.role.name)
    """
    return crud.team_member.update(db=db, obj_in=team_update_in, db_obj=db.get(TeamMember, id))
