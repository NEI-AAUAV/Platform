from typing import List
from datetime import timedelta

from fastapi import APIRouter, Depends, HTTPException
from fastapi.security import OAuth2PasswordRequestForm
from sqlalchemy.orm import Session

from app import crud
from app.api import deps
from app.schemas.user import Token, UserCreate, UserUpdate, UserInDB, AdminUserInDB

router = APIRouter()


@router.post("/token")
async def login(
    db: Session = Depends(deps.get_db),
    form_data: OAuth2PasswordRequestForm = Depends()
):
    user = deps.authenticate_user(
        db, form_data.username, form_data.password)
    if not user:
        raise HTTPException(
            status_code=401,
            detail="Incorrect username or password",
            headers={"WWW-Authenticate": "Bearer"},
        )
    access_token_expires = timedelta(minutes=deps.ACCESS_TOKEN_EXPIRE_MINUTES)
    access_token = deps.create_access_token(
        data={"sub": user.username}, expires_delta=access_token_expires
    )
    return {"access_token": access_token, "token_type": "bearer", "name": user.name,
            "staff_checkpoint_id": user.staff_checkpoint_id, "is_admin": user.is_admin}


@router.get("/", response_model=List[AdminUserInDB])
async def get_users(
    *, db: Session = Depends(deps.get_db),
    admin_user: UserInDB = Depends(deps.get_admin)
):
    return crud.user.get_multi(db=db)


@router.post("/", response_model=UserInDB)
async def create_user(
    *, db: Session = Depends(deps.get_db),
    obj_in: UserCreate,
    admin_user: UserInDB = Depends(deps.get_admin)
):
    if obj_in.team_id:
        team = crud.team.get(db=db, id=obj_in.team_id)
        if not team:
            raise HTTPException(status_code=404, detail="Team not found")
    return crud.user.create(db=db, obj_in=obj_in)


@router.put("/{id}", response_model=UserInDB)
async def create_user(
    *, db: Session = Depends(deps.get_db),
    id: int,
    obj_in: UserUpdate,
    admin_user: UserInDB = Depends(deps.get_admin)
):
    if obj_in.team_id:
        team = crud.team.get(db=db, id=obj_in.team_id)
        if not team:
            raise HTTPException(status_code=404, detail="Team not found")
    return crud.user.update(db=db, id=id, obj_in=obj_in)