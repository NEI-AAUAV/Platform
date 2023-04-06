from fastapi import APIRouter, Depends, Security
from sqlalchemy.orm import Session
from typing import List

from app import crud
from app.api import auth, deps
from app.schemas.match import Match, MatchUpdate

router = APIRouter()


@router.put(
    "/{id}",
    status_code=200,
    response_model=List[Match],
    responses={
        404: {
            "description": "Match Not Found / "
            "Exchange Match Not Found / "
            "Team In Modality Not Found"
        }
    },
)
async def update_match(
    id: int,
    match_in: MatchUpdate,
    db: Session = Depends(deps.get_db),
    _=Security(auth.verify_scopes, scopes=[auth.ScopeEnum.MANAGER_TACAUA]),
):
    return crud.match.update(db, id=id, obj_in=match_in)
