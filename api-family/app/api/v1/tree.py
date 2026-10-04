"""
Tree API endpoints for Family Tree.
Provides hierarchical tree structure of users.
"""

from typing import Annotated, Optional

from fastapi import APIRouter, HTTPException, Query

from app.crud.crud_user import user as crud_user
from app.schemas.tree import FamilyTree


router = APIRouter()


@router.get("/", status_code=200, response_model=FamilyTree, responses={404: {"description": "Resource not found"}})
def get_family_tree(
    root_id: Annotated[
        Optional[int],
        Query(description="Optional user ID to get subtree from. If not specified, returns full tree."),
    ] = None,
    depth: Annotated[
        Optional[int],
        Query(
            ge=0,
            le=50,
            description="Maximum depth to return. 0 = only root(s), 1 = root + direct children, etc. None = unlimited.",
        ),
    ] = None,
):
    """
    Get the family tree structure.
    
    - **Full tree**: Call without parameters to get complete hierarchy
    - **Subtree**: Specify `root_id` to get tree starting from a specific user
    - **Depth limit**: Use `depth` to limit nesting (useful for large trees)
    
    Response includes:
    - `roots`: Array of root nodes, each with nested `children`
    - `total_users`: Count of users in the returned tree
    """
    # Validate root_id if provided
    if root_id is not None and not crud_user.exists(root_id):
        raise HTTPException(status_code=404, detail=f"User {root_id} not found")
    
    roots, total = crud_user.get_tree(root_id=root_id, depth=depth)
    min_year, max_year = crud_user.get_year_range()
    return FamilyTree(roots=roots, total_users=total, min_year=min_year, max_year=max_year)
