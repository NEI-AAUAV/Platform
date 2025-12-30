"""
Role schemas for Family Tree API.
Roles represent positions in organizations (Faina, NEI, AETTUA, AAUAv).
"""

from typing import Optional, List
from pydantic import BaseModel, Field


class RoleBase(BaseModel):
    """Base role model."""
    name: str = Field(..., max_length=100, description="Role name")
    short: Optional[str] = Field(None, max_length=20, description="Short name/abbreviation")
    female_name: Optional[str] = Field(None, max_length=100, description="Female variant of the name")
    super_roles: str = Field("", description="Parent role path (e.g., '.1.' for Faina)")
    show: bool = Field(False, description="Show in main role list")


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


class RoleInDB(RoleBase):
    """Schema for role response from database."""
    id: str = Field(..., alias="_id", description="Role ID in path format (e.g., '.1.5.')")

    class Config:
        orm_mode = True
        allow_population_by_field_name = True


class RoleList(BaseModel):
    """Schema for paginated role list response."""
    items: List[RoleInDB]
    total: int
