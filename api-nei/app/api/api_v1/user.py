from fastapi import (
    APIRouter,
    Depends,
    HTTPException,
    Security,
    UploadFile,
    File,
    Form,
    Request,
)
from sqlalchemy.orm import Session
from typing import List, Optional, Set, Type, Union

from app import crud
from app.api import deps
from app.api.api_v1 import auth
from app.schemas import UserCreate, UserUpdate
from app.schemas.user import ScopeEnum
from app.schemas.user.user import (
    AdminUserListing,
    AnonymousUserListing,
    ManagerUserListing,
    UserListing,
)

router = APIRouter()

APIUserListing = Union[
    AnonymousUserListing, UserListing, ManagerUserListing, AdminUserListing
]


def user_listing_type(
    scopes: Optional[Set[str]] = None,
) -> Type[APIUserListing]:
    if scopes is None:
        return AnonymousUserListing

    model = UserListing

    for scope in scopes:
        if scope == ScopeEnum.MANAGER_NEI:
            model = ManagerUserListing
        elif scope == ScopeEnum.ADMIN:
            model = AdminUserListing
            break

    return model


@router.get("/", status_code=200, responses=auth.auth_responses)
async def get_users(
    *,
    db: Session = Depends(deps.get_db),
    auth_data: auth.AuthData = Security(
        auth.verify_token, scopes=[ScopeEnum.MANAGER_NEI]
    ),
) -> List[APIUserListing]:
    """Fetches all users"""
    ListingType = user_listing_type(auth_data.scopes)

    return list(map(lambda x: ListingType(**x.dict()), crud.user.get_multi(db=db)))


@router.get(
    "/me",
    status_code=200,
    response_model=AdminUserListing,
    responses=auth.auth_responses,
)
async def get_curr_user(
    *,
    db: Session = Depends(deps.get_db),
    payload: auth.AuthData = Security(auth.verify_token, scopes=[]),
):
    """ """
    id = int(payload.sub)

    user = crud.user.get(db=db, id=id)
    if not user:
        raise HTTPException(status_code=404, detail="Invalid User")

    return user


@router.get("/{id}", status_code=200, responses=auth.auth_responses)
async def get_user_by_id(
    *, id: int, db: Session = Depends(deps.get_db), auth_data: auth.GetAuthData
) -> APIUserListing:
    """ """
    user = crud.user.get(db=db, id=id)
    if not user:
        raise HTTPException(status_code=404, detail="User not found.")

    ListingType = user_listing_type(auth_data and auth_data.scopes)

    return ListingType(**user.dict())


# TODO: Does this method still make sense?
@router.post(
    "/", status_code=201, response_model=AdminUserListing, responses=auth.auth_responses
)
async def create_user(
    *,
    user_in: UserCreate,
    db: Session = Depends(deps.get_db),
    _=Security(auth.verify_token, scopes=[ScopeEnum.ADMIN]),
):
    """
    Create a new user in the database.
    """
    return crud.user.create(
        db=db,
        obj_in=user_in,
    )


def check_update_fields(update_form: UserUpdate, scopes: Set[str]):
    highest_scope = None
    for scope in scopes:
        if scope == ScopeEnum.ADMIN or (
            highest_scope is None and scope == ScopeEnum.MANAGER_NEI
        ):
            highest_scope = scope

    if not {"nmec"}.isdisjoint(update_form.model_fields_set) and highest_scope is None:
        raise HTTPException(status_code=403, detail="Invalid permissions.")

    if (
        not {"iupi", "scopes"}.isdisjoint(update_form.model_fields_set)
        and highest_scope != ScopeEnum.ADMIN
    ):
        raise HTTPException(status_code=403, detail="Invalid permissions.")


@router.put("/me", status_code=200, response_model=AdminUserListing)
async def update_curr_user(
    *,
    request: Request,
    user: UserUpdate = Form(),
    image: UploadFile = File(None),
    curriculum: UploadFile = File(None),
    db: Session = Depends(deps.get_db),
    auth_data: auth.AuthData = Security(auth.verify_token, scopes=[]),
) -> dict:
    """
    Update current user in the database.
    """
    check_update_fields(user, auth_data.scopes)

    user = crud.user.update_locked(db, id=auth_data.sub, obj_in=user)
    if not user:
        raise HTTPException(status_code=404, detail="User not found.")

    form = await request.form()
    if "image" in form:
        user = await crud.user.update_image(db=db, db_obj=user, image=image)
    if "curriculum" in form:
        user = await crud.user.update_curriculum(
            db=db, db_obj=user, curriculum=curriculum
        )

    return user


@router.put("/{id}", status_code=200, response_model=AdminUserListing)
async def update_user(
    *,
    user_in: UserUpdate,
    db: Session = Depends(deps.get_db),
    id: int,
    auth_data: auth.AuthData = Security(
        auth.verify_token, scopes=[ScopeEnum.MANAGER_NEI]
    ),
) -> dict:
    """
    Update a user in the database.
    """
    check_update_fields(user_in, auth_data.scopes)

    user = crud.user.update_locked(db=db, id=id, obj_in=user_in)
    if user is None:
        raise HTTPException(status_code=404, detail="User not found.")
    return user
