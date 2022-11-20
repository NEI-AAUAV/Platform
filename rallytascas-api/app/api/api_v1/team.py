from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import Any, Optional, List

from app import crud
from app.exception import NotFoundException
from app.api import deps
from app.core.logging import logger
from app.schemas.team import TeamCreate, TeamUpdate, TeamInDB, Checkpoint

router = APIRouter()

@router.get("/", status_code=200, response_model=List[TeamInDB])
def get_teams(
    *, db: Session = Depends(deps.get_db)
) -> Any:
    return crud.team.get_multi(db)


@router.put("/{id}/checkpoint", status_code=201, response_model=TeamInDB)
def add_checkpoint(
    id: int,
    checkpoint: Checkpoint, 
    db: Session = Depends(deps.get_db)
) -> Any:
    team = crud.team.get(db=db, id=id)
    if not team:
        raise NotFoundException(detail="Team Not Found")
    return crud.team.add_checkpoint(db=db, team=team, checkpoint=checkpoint)
