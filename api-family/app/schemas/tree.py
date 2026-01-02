"""
Tree schemas for Family Tree API.
Hierarchical tree structures for users and roles.
"""

from typing import Optional, List
from pydantic import BaseModel, Field


class UserRole(BaseModel):
    """A user's role/organization membership."""
    role_id: Optional[str] = None
    org_name: Optional[str] = None
    year: Optional[int] = None


class UserTreeNode(BaseModel):
    """A node in the user family tree."""
    id: int = Field(..., alias="_id")
    name: Optional[str] = None
    faina_name: Optional[str] = None
    sex: Optional[str] = None
    start_year: Optional[int] = None
    end_year: Optional[int] = None
    nmec: Optional[int] = None
    course_id: Optional[int] = None
    patrao_id: Optional[int] = None
    user_roles: List[UserRole] = Field(default_factory=list)
    children: List["UserTreeNode"] = Field(default_factory=list)
    has_more_children: Optional[bool] = Field(
        default=None, 
        description="Indicates additional children exist but were not included due to depth limit"
    )
    
    class Config:
        orm_mode = True
        allow_population_by_field_name = True


class FamilyTree(BaseModel):
    """Complete family tree response."""
    roots: List[UserTreeNode] = Field(..., description="Users without patrão (root nodes)")
    total_users: int = Field(..., description="Total number of users in returned tree")
    min_year: int = Field(..., description="Minimum start_year in the dataset")
    max_year: int = Field(..., description="Maximum start_year in the dataset")
    
    class Config:
        orm_mode = True


# Required for self-referencing model
UserTreeNode.update_forward_refs()
