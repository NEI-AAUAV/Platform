import orjson
import requests
from typing import Any

from sqlalchemy.orm import Session
from fastapi import APIRouter, Depends, Security, BackgroundTasks

from app import crud
from app.api import auth, deps
from app.api.logger_router import ContextIncludedRoute
from app.schemas.match import MatchUpdate, MatchList
from app.core.config import settings

router = APIRouter(route_class=ContextIncludedRoute)


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
) -> Any:
    data = MatchList(data=crud.match.update(db, id=id, obj_in=match_in))
    # not my fault we're using datetime
    background_tasks.add_task(
        ws_send_update, orjson.loads(orjson.dumps(data.model_dump()).decode())
    )
    return data


@router.get(
    "/last_played/",
    status_code=200,
    response_model=MatchList,
)
async def get_last_played(
    *,
    db: Session = Depends(deps.get_db),
    amount: int = 5,
) -> Any:
    return MatchList(data=crud.match.get_last_played(db, amount=amount))


@router.get(
    "/next_played",
    status_code=200,
    response_model=MatchList,
)
async def get_next_played(
    *,
    db: Session = Depends(deps.get_db),
    amount: int = 5,
) -> Any:
    return MatchList(data=crud.match.get_next_played(db, amount=amount))


def ws_send_update(data):
    requests.post(
        f"http://{settings.API_NEI_SERVER}:8000/api/nei/v1/ws/broadcast", json=data
    )


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
