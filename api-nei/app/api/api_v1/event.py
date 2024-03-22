from fastapi import (
    APIRouter,
    BackgroundTasks,
    Depends,
    HTTPException,
    Security,
)
from pydantic import BaseModel
from sqlalchemy.orm import Session
from typing import List

from app import crud
from app.api import deps
from app.api.api_v1 import auth
from app.schemas.user import ScopeEnum
from app.schemas.user.user import UserCreateForEvent
from app.api.api_v1.auth.magic_link import send_magic_link
from app.schemas.event import CreateEvent, ListingEvent, UpdateEvent, DetailedEvent

router = APIRouter()


@router.get("/", status_code=200)
async def get_events(
    *,
    db: Session = Depends(deps.get_db),
) -> List[ListingEvent]:
    """
    Fetches all existing events.
    """
    return crud.event.get_multi(db=db)


@router.get("/{id}", status_code=200)
async def get_event_by_id(
    *,
    id: int,
    db: Session = Depends(deps.get_db),
) -> DetailedEvent:
    """
    Fetches an event by it's identifier.
    """
    event = crud.event.get(db=db, id=id)
    if event is None:
        raise HTTPException(status_code=404, detail="Event not found")
    return DetailedEvent.model_validate(event)


@router.put("/{id}", status_code=200)
async def update_event(
    *,
    id: int,
    event_in: UpdateEvent,
    db: Session = Depends(deps.get_db),
    _=Security(auth.verify_token, scopes=[ScopeEnum.MANAGER_NEI]),
) -> DetailedEvent:
    """
    Updates an existing event.
    """
    event = crud.event.update_locked(db=db, id=id, obj_in=event_in)
    if event is None:
        raise HTTPException(status_code=404, detail="Event not found")
    return DetailedEvent.model_validate(event)


@router.post("/", status_code=201)
async def create_event(
    *,
    event_in: CreateEvent,
    db: Session = Depends(deps.get_db),
    _=Security(auth.verify_token, scopes=[ScopeEnum.MANAGER_NEI]),
) -> DetailedEvent:
    """
    Creates a new event.
    """
    event = crud.event.create(db=db, obj_in=event_in)
    return DetailedEvent.model_validate(event)


class ImportUsersResult(BaseModel):
    users_created: int


@router.post("/{id}", status_code=201)
async def import_users_for_event(
    *,
    id: int,
    users: List[UserCreateForEvent],
    db: Session = Depends(deps.get_db),
    background_tasks: BackgroundTasks,
    _=Security(auth.verify_token, scopes=[ScopeEnum.MANAGER_NEI]),
) -> ImportUsersResult:
    """
    Imports users for an event.
    """
    result = crud.event.import_users(db, id=id, users=users)
    if result is None:
        raise HTTPException(status_code=404, detail="Event not found")
    for user, user_email in result.created_users:
        send_magic_link(
            user,
            user_email.email,
            background_tasks,
            (
                f"Estás inscrito no {result.event.name}, como tal foi criada uma"
                " "
                "conta no NEI que te garante acesso aos conteúdos online do evento"
            ),
        )
    return ImportUsersResult(users_created=len(result.created_users))


@router.delete("/{id}", status_code=201)
async def delete_event(
    *,
    id: int,
    db: Session = Depends(deps.get_db),
    _=Security(auth.verify_token, scopes=[ScopeEnum.MANAGER_NEI]),
) -> DetailedEvent:
    """
    Deletes an existing event.
    """
    event = crud.event.delete(db=db, id=id)
    if event is None:
        raise HTTPException(status_code=404, detail="Event not found")
    return DetailedEvent.model_validate(event)
