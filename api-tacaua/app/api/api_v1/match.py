from fastapi import APIRouter, Depends, HTTPException, Security, BackgroundTasks
import requests
from sqlalchemy.orm import Session
from typing import Any, Optional

from app import crud
from app.api import auth, deps
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
    db: Session = Depends(deps.get_db),
    _=Security(auth.verify_scopes, scopes=[auth.ScopeEnum.MANAGER_TACAUA]),
) -> Any:
    data = crud.match.update(db, id=id, obj_in=match_in)
    BackgroundTasks.add_task(ws_send_update, data)
    return data


def ws_send_update(data):
    requests.post("http://localhost:8000/api/nei/v1/ws/broadcast")
    