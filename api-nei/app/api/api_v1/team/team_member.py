from fastapi import APIRouter, Depends, HTTPException, Query, Response
from sqlalchemy.orm import Session
from typing import Any, List

from app import crud
from app.api import deps
from app.schemas import TeamMemberCreate, TeamMemberInDB, TeamMemberUpdate, TeamMandates
from app.models.team_member import TeamMember

router = APIRouter()


@router.get("/mandates", status_code=200, response_model=TeamMandates)
def get_team_members(
    *, db: Session = Depends(deps.get_db), response : Response
) -> Any:
    """
    Return all mandates.
    """
    response.headers["cache-control"] = "private, max-age=15552000, no-cache"
    data = crud.team_member.get_team_mandates(db=db)
    print(data)
    data = [e[0] for e in data]
    return {"data": data}


@router.get("/{mandate}", status_code=200, response_model=List[TeamMemberInDB])
def get_team_members_by_mandate(
    *, db: Session = Depends(deps.get_db), mandate: str, response : Response
) -> Any:
    response.headers["cache-control"] = "private, max-age=15552000, no-cache" 
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
    return crud.team_member.update(db=db, obj_in=team_update_in, db_obj=db.get(TeamMember, id))
