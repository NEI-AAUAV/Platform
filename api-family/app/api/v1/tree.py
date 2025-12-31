"""
Tree API endpoints for Family Tree.
Provides hierarchical tree structure of users.
"""

from typing import Optional

from fastapi import APIRouter, HTTPException, Query

from app.crud.crud_user import user as crud_user
from app.schemas.tree import FamilyTree


router = APIRouter()


@router.get("/", status_code=200, response_model=FamilyTree)
def get_family_tree(
    root_id: Optional[int] = Query(
        default=None, 
        description="Optional user ID to get subtree from. If not specified, returns full tree."
    ),
    depth: Optional[int] = Query(
        default=None, 
        ge=0, 
        le=50,
        description="Maximum depth to return. 0 = only root(s), 1 = root + direct children, etc. None = unlimited."
    ),
):
    """
    Get the family tree structure.
    
    - **Full tree**: Call without parameters to get complete hierarchy
    - **Subtree**: Specify `root_id` to get tree starting from a specific user
    - **Depth limit**: Use `depth` to limit nesting (useful for large trees)
    
    Response includes:
    - `roots`: Array of root nodes, each with nested `children`
    - `total_users`: Count of users in the returned tree
    
    Tree data is cached for 60 seconds for performance.
    """
    # Validate root_id if provided
    if root_id is not None and not crud_user.exists(root_id):
        raise HTTPException(status_code=404, detail=f"User {root_id} not found")
    
    roots, total = crud_user.get_tree(root_id=root_id, depth=depth)
    return FamilyTree(roots=roots, total_users=total)


@router.delete("/cache", status_code=204)
def invalidate_tree_cache():
    """
    Invalidate the tree cache.
    
    Use this after bulk operations to force fresh data on next request.
    Note: Cache is automatically invalidated on user create/update/delete.
    """
    crud_user.invalidate_tree_cache()
    return None
