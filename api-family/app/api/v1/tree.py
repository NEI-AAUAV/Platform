"""
Tree API endpoints for Family Tree.
Provides hierarchical tree structure of users.
"""

from fastapi import APIRouter

from app.crud.crud_user import user as crud_user
from app.schemas.tree import FamilyTree


router = APIRouter()


@router.get("/", status_code=200, response_model=FamilyTree)
def get_family_tree():
    """
    Get the complete family tree.
    
    Returns hierarchical structure with:
    - roots: Users without patrão (root nodes)
    - Each user has children (pedaços) nested recursively
    - Sorted by start_year at each level
    """
    roots, total = crud_user.get_tree()
    return FamilyTree(roots=roots, total_users=total)
