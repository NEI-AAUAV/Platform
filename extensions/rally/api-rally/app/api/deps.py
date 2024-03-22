from typing import Generator, List

from fastapi import Depends, HTTPException, Security
from sqlalchemy.orm import Session

from app import crud
from app.db.session import SessionLocal
from app.models.user import User
from app.schemas.user import DetailedUser, UserCreate
from app.api.auth import AuthData, ScopeEnum, api_nei_auth


def get_db() -> Generator[Session, None, None]:
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


async def get_current_user(
    auth: AuthData = Security(api_nei_auth, scopes=[]),
    db: Session = Depends(get_db),
) -> DetailedUser:
    user = db.get(User, auth.sub)
    if user is None:
        user = crud.user.create(
            db, obj_in=UserCreate(id=auth.sub, name=f"{auth.name} {auth.surname}")
        )
    return DetailedUser.model_validate(user)


async def get_participant(
    curr_user: DetailedUser = Depends(get_current_user),
) -> DetailedUser:
    if curr_user.disabled:
        raise HTTPException(status_code=400, detail="Inactive user")
    return curr_user


def is_admin(scopes: List[str]) -> bool:
    return any(scope in [ScopeEnum.MANAGER_RALLY, ScopeEnum.ADMIN] for scope in scopes)


async def get_admin(
    auth: AuthData = Security(api_nei_auth, scopes=[]),
    curr_user: DetailedUser = Depends(get_participant),
) -> DetailedUser:
    if not is_admin(auth.scopes):
        raise HTTPException(status_code=403, detail="User without admin permissions")
    return curr_user


async def get_admin_or_staff(
    auth: AuthData = Security(api_nei_auth, scopes=[]),
    curr_user: DetailedUser = Depends(get_participant),
) -> DetailedUser:
    if not is_admin(auth.scopes) and curr_user.staff_checkpoint_id is None:
        raise HTTPException(status_code=403, detail="User without permissions")
    return curr_user
