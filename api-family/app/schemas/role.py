"""
Role schemas for Family Tree API.
Roles represent positions in organizations (Faina, NEI, AETTUA, AAUAv).
"""

from typing import Optional, List
from pydantic import AliasChoices, BaseModel, ConfigDict, Field


class RoleBase(BaseModel):
    """Base role model."""
    name: str = Field(..., max_length=100, description="Role name")
    short: Optional[str] = Field(None, max_length=20, description="Short name/abbreviation")
    female_name: Optional[str] = Field(None, max_length=100, description="Female variant of the name")
    super_roles: str = Field("", description="Parent role path (e.g., '.1.' for Faina)")
    show: bool = Field(False, description="Show in main role list")
    year_display_format: str = Field("civil", description="Year display format: 'civil' (2023) or 'academic' (23/24)")
    icon: Optional[str] = Field(None, description="Icon URL or path")
    hidden: bool = Field(False, description="Hide from public visualizations (Tree/Table)")


class RoleCreate(RoleBase):
    """Schema for creating a new role."""
    pass


class RoleUpdate(BaseModel):
    """Schema for updating a role. All fields optional."""
    name: Optional[str] = Field(None, max_length=100)
    short: Optional[str] = Field(None, max_length=20)
    female_name: Optional[str] = Field(None, max_length=100)
    super_roles: Optional[str] = None
    show: Optional[bool] = None
    year_display_format: Optional[str] = None
    icon: Optional[str] = None
    hidden: Optional[bool] = None


class RoleInDB(RoleBase):
    """Schema for role response from database."""
    id: str = Field(
        ...,
        validation_alias=AliasChoices('_id', 'id'), serialization_alias='id',
        description="Role ID in path format (e.g., '.1.5.') - MongoDB _id",
    )

    def model_dump(self, **kwargs):
        """Override model_dump() to always use field names (not aliases) for serialization."""
        # Force by_alias=False to serialize as 'id' instead of '_id'
        # Important: this ensures frontend gets 'id' consistently
        kwargs['by_alias'] = False
        return super().model_dump(**kwargs)

    model_config = ConfigDict(from_attributes=True, populate_by_name=True)


class RoleTreeNode(RoleInDB):
    """Schema for a role in a tree structure."""
    children: List["RoleTreeNode"] = Field(default_factory=list)


class RoleList(BaseModel):
    """Schema for paginated role list response."""
    items: List[RoleInDB]
    total: int


# Required for self-referencing model
RoleTreeNode.update_forward_refs()
