from typing import List
from datetime import timedelta

from fastapi import APIRouter, Depends, HTTPException
from fastapi.security import OAuth2PasswordRequestForm
from pydantic import TypeAdapter
from sqlalchemy.orm import Session

from app import crud
from app.api import deps
from app.schemas.user import (
    AdminListingUser,
    LoginResult,
    UserUpdate,
    DetailedUser,
    AdminUser,
)

router = APIRouter()


@router.post("/token")
async def login(
    db: Session = Depends(deps.get_db), form_data: OAuth2PasswordRequestForm = Depends()
) -> LoginResult:
    user = deps.authenticate_user(db, form_data.username, form_data.password)
    if not user:
        raise HTTPException(
            status_code=401,
            detail="Incorrect username or password",
            headers={"WWW-Authenticate": "Bearer"},
        )
    access_token_expires = timedelta(minutes=deps.ACCESS_TOKEN_EXPIRE_MINUTES)
    access_token = deps.create_access_token(
        data={"sub": str(user.id)}, expires_delta=access_token_expires
    )
    return LoginResult(
        access_token=access_token,
        token_type="bearer",
        name=user.name,
        staff_checkpoint_id=user.staff_checkpoint_id,
        is_admin=user.is_admin,
    )


@router.get("/")
async def get_users(
    *, db: Session = Depends(deps.get_db), _: AdminUser = Depends(deps.get_admin)
) -> List[AdminListingUser]:
    AdminListingUserListAdapter = TypeAdapter(List[AdminListingUser])
    return AdminListingUserListAdapter.validate_python(crud.user.get_multi(db=db))


@router.put("/{id}", response_model=DetailedUser)
async def update_user(
    *,
    db: Session = Depends(deps.get_db),
    id: int,
    obj_in: UserUpdate,
    _: AdminUser = Depends(deps.get_admin)
):
    return crud.user.update(db=db, id=id, obj_in=obj_in)
