from fastapi import APIRouter, Depends, HTTPException, Query, Security, UploadFile, File, Form, Request
from sqlalchemy.orm import Session
from typing import Any, List

from app import crud
from app.api import deps
from app.api.api_v1 import auth
from app.models import User
from app.schemas import UserCreate, UserUpdate, UserInDB
from app.schemas.user import ScopeEnum

router = APIRouter()


@router.get("/", status_code=200, response_model=List[UserInDB])
async def get_users(
    *,
    db: Session = Depends(deps.get_db),
    _=Security(auth.verify_token, scopes=[ScopeEnum.MANAGER_NEI]),
) -> Any:
    """ """
    return crud.user.get_multi(db=db)


@router.get("/me", status_code=200, response_model=UserInDB)
async def get_curr_user(
    *,
    db: Session = Depends(deps.get_db),
    payload = Security(auth.verify_token, scopes=[])
) -> Any:
    """ """
    id = int(payload["sub"])

    user = crud.user.get(db=db, id=id)
    if not user:
        raise HTTPException(status_code=404, detail="Invalid User")
    
    return user


@router.get("/{id}", status_code=200, response_model=UserInDB)
async def get_user_by_id(
    *,
    id: int,
    db: Session = Depends(deps.get_db),
) -> Any:
    """ """
    user = crud.user.get(db=db, id=id)
    if not user:
        raise HTTPException(status_code=404, detail="User not found.")
    return user


@router.post("/", status_code=201, response_model=UserInDB)
async def create_user(*, user_in: UserCreate, db: Session = Depends(deps.get_db)) -> dict:
    """
    Create a new user in the database.
    """
    return crud.user.create(db=db, obj_in=user_in)


@router.put("/me", status_code=200, response_model=UserInDB)
async def update_curr_user(
    *, request: Request,
    user_in: UserUpdate = Form(..., alias='user'),
    image: UploadFile = File(None),
    curriculum: UploadFile = File(None),
    db: Session = Depends(deps.get_db), 
    payload = Security(auth.verify_token, scopes=[])
) -> dict:
    """
    Update current user in the database.
    """
    id = int(payload["sub"])

    user = crud.user.get(db=db, id=id)
    if not user:
        raise HTTPException(status_code=404, detail="User not found.")
    
    user = crud.user.update(db, db_obj=user, obj_in=user_in)
    form = await request.form()
    if 'image' in form:
        user = await crud.user.update_image(
            db=db, db_obj=user, image=image)
    if 'curriculum' in form:
        user = await crud.user.update_curriculum(
            db=db, db_obj=user, curriculum=curriculum)

    return user


@router.put("/{id}", status_code=200, response_model=UserInDB)
async def update_user(
    *, user_in: UserUpdate, db: Session = Depends(deps.get_db), id: int
) -> dict:
    """
    Update a user in the database.
    """
    user = crud.user.get(db=db, id=id)
    if not user:
        raise HTTPException(status_code=404, detail="User not found.")

    return crud.note.update(db=db, obj_in=user_in, db_obj=user)
