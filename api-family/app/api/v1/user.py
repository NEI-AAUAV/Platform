"""
User API endpoints for Family Tree.
"""

from typing import List, Optional

from fastapi import APIRouter, HTTPException, Query, Security

from app.api import auth
from app.crud.crud_user import user as crud_user
from app.crud.crud_course import course as crud_course
from app.schemas.user import UserCreate, UserUpdate, UserInDB, UserList


router = APIRouter()


@router.get("/", status_code=200, response_model=UserList)
def get_users(
    skip: int = Query(default=0, ge=0, description="Number of records to skip"),
    limit: int = Query(default=100, ge=1, le=500, description="Max records to return"),
    start_year_gte: Optional[int] = Query(default=None, alias="from_year", description="Filter by start_year >= value"),
    patrao_id: Optional[int] = Query(default=None, description="Filter by patrao_id"),
):
    """
    List users with optional filters.
    
    - **skip**: Number of records to skip (pagination)
    - **limit**: Maximum number of records to return
    - **from_year**: Filter users with start_year >= this value
    - **patrao_id**: Filter users by their patrão
    """
    users = crud_user.get_multi(
        skip=skip, 
        limit=limit, 
        start_year_gte=start_year_gte,
        patrao_id=patrao_id
    )
    
    total = crud_user.count()
    
    return UserList(
        items=users,
        total=total,
        skip=skip,
        limit=limit
    )


@router.get("/{id}", status_code=200, response_model=UserInDB)
def get_user(id: int):
    """
    Get a single user by ID.
    """
    user = crud_user.get(id)
    if not user:
        raise HTTPException(status_code=404, detail=f"User with id {id} not found")
    return user


@router.get("/{id}/children", status_code=200, response_model=List[UserInDB])
def get_user_children(id: int):
    """
    Get all children (pedaços) of a user.
    """
    if not crud_user.exists(id):
        raise HTTPException(status_code=404, detail=f"User with id {id} not found")
    
    children = crud_user.get_children(id)
    return children


@router.post("/", status_code=201, response_model=UserInDB)
def create_user(
    obj_in: UserCreate,
    _=Security(auth.verify_scopes, scopes=[auth.ScopeEnum.MANAGER_FAMILY]),
):
    """
    Create a new user. Requires MANAGER_FAMILY scope.
    
    - **name**: Full name (required)
    - **sex**: M or F (required)
    - **start_year**: Year of entry, 2 digits (required)
    - **patrao_id**: ID of the patrão (optional, null for roots)
    - **faina_name**: Faina name (optional, auto-generated from last name if not provided)
    """
    # Validate patrao_id exists if provided
    if obj_in.patrao_id is not None:
        if not crud_user.exists(obj_in.patrao_id):
            raise HTTPException(
                status_code=400, 
                detail=f"Patrão with id {obj_in.patrao_id} not found"
            )
    
    # Validate course_id exists if provided
    if obj_in.course_id is not None:
        if not crud_course.exists(obj_in.course_id):
            raise HTTPException(
                status_code=400, 
                detail=f"Course with id {obj_in.course_id} not found"
            )
    
    # Validate nmec is unique if provided
    if obj_in.nmec is not None:
        existing = crud_user.get_by_nmec(obj_in.nmec)
        if existing:
            raise HTTPException(
                status_code=400,
                detail=f"User with nmec {obj_in.nmec} already exists"
            )
    
    user = crud_user.create(obj_in=obj_in)
    return user


@router.put("/{id}", status_code=200, response_model=UserInDB)
def update_user(
    id: int,
    obj_in: UserUpdate,
    _=Security(auth.verify_scopes, scopes=[auth.ScopeEnum.MANAGER_FAMILY]),
):
    """
    Update a user. Requires MANAGER_FAMILY scope.
    Only provided fields will be updated.
    """
    # Check user exists
    if not crud_user.exists(id):
        raise HTTPException(status_code=404, detail=f"User with id {id} not found")
    
    # Validate patrao_id if being updated
    if obj_in.patrao_id is not None:
        if obj_in.patrao_id == id:
            raise HTTPException(status_code=400, detail="User cannot be their own patrão")
        if not crud_user.exists(obj_in.patrao_id):
            raise HTTPException(
                status_code=400, 
                detail=f"Patrão with id {obj_in.patrao_id} not found"
            )
    
    # Validate course_id if being updated
    if obj_in.course_id is not None:
        if not crud_course.exists(obj_in.course_id):
            raise HTTPException(
                status_code=400, 
                detail=f"Course with id {obj_in.course_id} not found"
            )
    
    # Validate nmec uniqueness if being updated
    if obj_in.nmec is not None:
        existing = crud_user.get_by_nmec(obj_in.nmec)
        if existing and existing["_id"] != id:
            raise HTTPException(
                status_code=400,
                detail=f"User with nmec {obj_in.nmec} already exists"
            )
    
    user = crud_user.update(id=id, obj_in=obj_in)
    return user


@router.delete("/{id}", status_code=204)
def delete_user(
    id: int,
    _=Security(auth.verify_scopes, scopes=[auth.ScopeEnum.MANAGER_FAMILY]),
):
    """
    Delete a user. Requires MANAGER_FAMILY scope.
    
    Warning: This will leave orphaned children (pedaços).
    Consider reassigning them first.
    """
    if not crud_user.exists(id):
        raise HTTPException(status_code=404, detail=f"User with id {id} not found")
    
    # Check for children (pedaços)
    children = crud_user.get_children(id)
    if children:
        raise HTTPException(
            status_code=400,
            detail=f"Cannot delete user with {len(children)} children. Reassign them first."
        )
    
    crud_user.delete(id=id)
    return None
