from typing import Any, List, Optional

from fastapi import APIRouter, Depends, HTTPException, Query

from app import crud
from app.exception import NotFoundException
from app.core.logging import logger
from app.schemas.user import UserCreate, UserUpdate, UserAdminUpdate, UserInDB


router = APIRouter()


@router.get("/", status_code=200, response_model=List[UserInDB])
def get_users(
    mode: str = Query(default=..., alias='from', examples=['faina', 'all']),
    until: int = Query(default=5, description='Number of years ago')
) -> Any:
    ...


@router.post("/", status_code=201, response_model=UserInDB)
def create_user(
    obj_in: UserCreate,
) -> Any:
    # TODO: only with admin permissions
    ...


@router.put("/{id}", status_code=201, response_model=UserInDB)
def update_user(
    id: int,
    obj_in: UserAdminUpdate,
) -> Any:
    # TODO: only with admin permissions
    ...


@router.put("/me", status_code=201, response_model=UserInDB, 
            description='Finds the user referenced to the active user and updates it')
def update_own_user(
    obj_in: UserUpdate,
) -> Any:
    ...
