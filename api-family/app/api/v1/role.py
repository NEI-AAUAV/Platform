"""
Role API endpoints for Family Tree.
"""

from typing import List, Optional, Any

from fastapi import APIRouter, HTTPException, Query, Security

from app.api import auth
from app.crud.crud_role import role as crud_role
from app.schemas.role import RoleCreate, RoleUpdate, RoleInDB, RoleList


router = APIRouter()


@router.get("/", status_code=200, response_model=RoleList)
def get_roles(
    skip: int = Query(default=0, ge=0),
    limit: int = Query(default=100, ge=1, le=500),
    show_only: bool = Query(default=False, description="Only return roles with show=true"),
    parent: Optional[str] = Query(default=None, description="Filter by parent role ID"),
):
    """
    List roles with optional filters.
    
    - **show_only**: Only return main/visible roles
    - **parent**: Filter by parent role (e.g., '.1.' for Faina sub-roles)
    """
    roles = crud_role.get_multi(
        skip=skip, 
        limit=limit, 
        show_only=show_only,
        parent=parent
    )
    total = crud_role.count()
    
    return RoleList(items=roles, total=total)


@router.get("/tree", status_code=200)
def get_roles_tree() -> Any:
    """
    Get all roles organized as a hierarchical tree.
    
    Returns nested structure with children arrays.
    """
    return crud_role.get_tree()


@router.get("/{id}", status_code=200, response_model=RoleInDB)
def get_role(id: str):
    """
    Get a single role by ID.
    
    Role IDs are in path format (e.g., '.1.5.' for CF under Faina).
    """
    role = crud_role.get(id)
    if not role:
        raise HTTPException(status_code=404, detail=f"Role with id {id} not found")
    return role


@router.get("/{id}/children", status_code=200, response_model=List[RoleInDB])
def get_role_children(id: str):
    """
    Get all child roles of a given role.
    """
    if not crud_role.exists(id):
        raise HTTPException(status_code=404, detail=f"Role with id {id} not found")
    
    children = crud_role.get_children(id)
    return children


@router.post("/", status_code=201, response_model=RoleInDB)
def create_role(
    obj_in: RoleCreate,
    _=Security(auth.verify_scopes, scopes=[auth.ScopeEnum.MANAGER_FAMILY]),
):
    """
    Create a new role. Requires MANAGER_FAMILY scope.
    
    The role ID is auto-generated based on the parent role.
    """
    # Validate parent exists if provided
    if obj_in.super_roles and not crud_role.exists(obj_in.super_roles):
        raise HTTPException(
            status_code=400, 
            detail=f"Parent role {obj_in.super_roles} not found"
        )
    
    role = crud_role.create(obj_in=obj_in)
    return role


@router.put("/{id}", status_code=200, response_model=RoleInDB)
def update_role(
    id: str,
    obj_in: RoleUpdate,
    _=Security(auth.verify_scopes, scopes=[auth.ScopeEnum.MANAGER_FAMILY]),
):
    """
    Update a role. Requires MANAGER_FAMILY scope.
    """
    if not crud_role.exists(id):
        raise HTTPException(status_code=404, detail=f"Role with id {id} not found")
    
    # Validate new parent if being updated
    if obj_in.super_roles is not None and obj_in.super_roles != "":
        if not crud_role.exists(obj_in.super_roles):
            raise HTTPException(
                status_code=400, 
                detail=f"Parent role {obj_in.super_roles} not found"
            )
    
    role = crud_role.update(id=id, obj_in=obj_in)
    return role


@router.delete("/{id}", status_code=204)
def delete_role(
    id: str,
    _=Security(auth.verify_scopes, scopes=[auth.ScopeEnum.MANAGER_FAMILY]),
):
    """
    Delete a role. Requires MANAGER_FAMILY scope.
    
    Cannot delete roles that have children.
    """
    if not crud_role.exists(id):
        raise HTTPException(status_code=404, detail=f"Role with id {id} not found")
    
    # Check for children
    children = crud_role.get_children(id)
    if children:
        raise HTTPException(
            status_code=400,
            detail=f"Cannot delete role with {len(children)} child roles"
        )
    
    crud_role.delete(id=id)
    return None
