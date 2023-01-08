from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import Any, Optional

from app import crud
from app.api import deps
from app.core.logging import logger
from app.schemas.match import Match, MatchCreate, MatchUpdate

router = APIRouter()

responses = {
    404: {'description': "Match Not Found"},
}


@router.put("/{id}", status_code=200, response_model=Match,
            responses={404: {'description': "Match Not Found / "
                             "Exchange Match Not Found / "
                             "Team In Modality Not Found"}})
async def update_match(
    id: int,
    match_in: MatchUpdate,
    db: Session = Depends(deps.get_db)
) -> Any:
    return crud.match.update(db, id=id, obj_in=match_in)
