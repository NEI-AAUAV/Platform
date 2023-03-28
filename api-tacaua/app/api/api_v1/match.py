from fastapi import APIRouter, Depends, HTTPException, Security, BackgroundTasks
import requests
from sqlalchemy.orm import Session
from typing import List
from loguru import logger
from app import crud
from app.api import auth, deps
from app.schemas.match import Match, MatchUpdate, MatchList
from typing import Any
import orjson
from app.core.config import settings

router = APIRouter()


@router.put(
    "/{id}",
    status_code=200,
    response_model=MatchList,
    responses={
        404: {
            "description": "Match Not Found / "
            "Exchange Match Not Found / "
            "Team In Modality Not Found"
        }
    },
)
async def update_match(
    *,
    id: int,
    match_in: MatchUpdate,
    db: Session = Depends(deps.get_db),
    _=Security(auth.verify_scopes, scopes=[auth.ScopeEnum.MANAGER_TACAUA]),
    background_tasks: BackgroundTasks,
) -> any:
    data = MatchList(data = crud.match.update(db, id=id, obj_in=match_in))
                                                # not my fault we're using datetime
    background_tasks.add_task(ws_send_update, orjson.loads(orjson.dumps(data.dict()).decode()))
    return data


def ws_send_update(data):
    requests.post(f"http://{settings.API_NEI_SERVER}:8000/api/nei/v1/ws/broadcast", json=data)
    
""" jic

@router.post(
    "/test",
    status_code=200,
    response_model=Any,
)
async def test(
    *,
    match_in: dict,
    background_tasks: BackgroundTasks,
) -> Any:
    logger.info(match_in)
    background_tasks.add_task(ws_send_update, match_in)
    return match_in
"""