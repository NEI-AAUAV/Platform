"""
UserRole API endpoints for Family Tree.
Associates users with roles for specific years.
"""

from typing import Optional

from fastapi import APIRouter, HTTPException, Query, Security

from app.api import auth
from app.crud.crud_userrole import user_role as crud_user_role
from app.crud.crud_user import user as crud_user
from app.crud.crud_role import role as crud_role
from app.schemas.userrole import (
    UserRoleCreate, UserRoleInDB, 
    UserRoleList, UserRoleDetailsList
)


router = APIRouter()


@router.get("/", status_code=200, response_model=UserRoleList)
def get_user_roles(
    skip: int = Query(default=0, ge=0),
    limit: int = Query(default=100, ge=1, le=500),
    user_id: Optional[int] = Query(default=None, description="Filter by user ID"),
    role_id: Optional[str] = Query(default=None, description="Filter by role ID"),
    year: Optional[int] = Query(default=None, ge=0, le=99, description="Filter by year (0-99)"),
):
    """
    List user-role associations with optional filters.
    """
    user_roles = crud_user_role.get_multi(
        skip=skip, 
        limit=limit, 
        user_id=user_id,
        role_id=role_id,
        year=year
    )
    total = crud_user_role.count(user_id=user_id, role_id=role_id, year=year)
    
    return UserRoleList(items=user_roles, total=total, skip=skip, limit=limit)


@router.get("/details", status_code=200, response_model=UserRoleDetailsList)
def get_user_roles_with_details(
    skip: int = Query(default=0, ge=0),
    limit: int = Query(default=100, ge=1, le=500),
    user_id: Optional[int] = Query(default=None, description="Filter by user ID"),
    role_id: Optional[str] = Query(default=None, description="Filter by role ID"),
    year: Optional[int] = Query(default=None, ge=0, le=99, description="Filter by year (0-99)"),
):
    """
    Get user-roles with expanded user and role details.
    Includes pagination support.
    """
    items, total = crud_user_role.get_with_details(
        user_id=user_id,
        role_id=role_id,
        year=year,
        skip=skip,
        limit=limit
    )
    return UserRoleDetailsList(items=items, total=total, skip=skip, limit=limit)


@router.get("/user/{user_id}", status_code=200, response_model=UserRoleDetailsList)
def get_roles_for_user(
    user_id: int,
    skip: int = Query(default=0, ge=0),
    limit: int = Query(default=100, ge=1, le=500),
):
    """
    Get all roles for a specific user with details.
    Supports pagination.
    """
    if not crud_user.exists(user_id):
        raise HTTPException(status_code=404, detail=f"User {user_id} not found")
    
    items, total = crud_user_role.get_with_details(
        user_id=user_id,
        skip=skip,
        limit=limit
    )
    return UserRoleDetailsList(items=items, total=total, skip=skip, limit=limit)


@router.get("/role/{role_id:path}", status_code=200, response_model=UserRoleDetailsList)
def get_users_for_role(
    role_id: str,
    skip: int = Query(default=0, ge=0),
    limit: int = Query(default=100, ge=1, le=500),
):
    """
    Get all users with a specific role with details.
    Supports pagination.
    """
    if not crud_role.exists(role_id):
        raise HTTPException(status_code=404, detail=f"Role {role_id} not found")
    
    items, total = crud_user_role.get_with_details(
        role_id=role_id,
        skip=skip,
        limit=limit
    )
    return UserRoleDetailsList(items=items, total=total, skip=skip, limit=limit)


@router.post("/", status_code=201, response_model=UserRoleInDB)
def create_user_role(
    obj_in: UserRoleCreate,
    _=Security(auth.verify_scopes, scopes=[auth.ScopeEnum.MANAGER_FAMILY]),
):
    """
    Create a new user-role association. Requires MANAGER_FAMILY scope.
    """
    # Validate user exists
    if not crud_user.exists(obj_in.user_id):
        raise HTTPException(status_code=404, detail=f"User {obj_in.user_id} not found")
    
    # Validate role exists
    if not crud_role.exists(obj_in.role_id):
        raise HTTPException(status_code=404, detail=f"Role {obj_in.role_id} not found")
    
    # Check for duplicate
    if crud_user_role.exists(obj_in.user_id, obj_in.role_id, obj_in.year):
        raise HTTPException(
            status_code=409, 
            detail=f"User {obj_in.user_id} already has role {obj_in.role_id} for year {obj_in.year}"
        )
    
    user_role = crud_user_role.create(obj_in=obj_in)
    if not user_role:
        raise HTTPException(
            status_code=500,
            detail="Failed to create user-role association"
        )
    return user_role


@router.delete("/{id}", status_code=204)
def delete_user_role(
    id: str,
    _=Security(auth.verify_scopes, scopes=[auth.ScopeEnum.MANAGER_FAMILY]),
):
    """
    Delete a user-role association. Requires MANAGER_FAMILY scope.
    """
    if not crud_user_role.delete(id=id):
        raise HTTPException(status_code=404, detail=f"UserRole {id} not found")
    return None
