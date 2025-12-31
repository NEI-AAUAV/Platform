"""
UserRole schemas for Family Tree API.
Associates users with roles for specific years.
"""

from typing import Optional, List
from pydantic import BaseModel, Field


class UserRoleBase(BaseModel):
    """Base user-role association model."""
    user_id: int = Field(..., description="User ID")
    role_id: str = Field(..., description="Role ID (path format, e.g. '.1.5.')")
    year: int = Field(..., ge=0, le=99, description="Year of the role (2 digits)")


class UserRoleCreate(UserRoleBase):
    """Schema for creating a new user-role association."""
    pass


class UserRoleUpdate(BaseModel):
    """Schema for updating a user-role. Only year can be updated."""
    year: Optional[int] = Field(None, ge=0, le=99)


class UserRoleInDB(UserRoleBase):
    """Schema for user-role response from database."""
    id: str = Field(..., alias="_id")

    class Config:
        orm_mode = True
        allow_population_by_field_name = True


class UserRoleWithDetails(BaseModel):
    """User-role with expanded user and role info."""
    id: str = Field(..., alias="_id")
    user_id: int
    role_id: str
    year: int
    user_name: Optional[str] = None
    role_name: Optional[str] = None
    role_short: Optional[str] = None

    class Config:
        orm_mode = True
        allow_population_by_field_name = True


class UserRoleList(BaseModel):
    """Schema for paginated user-role list response."""
    items: List[UserRoleInDB]
    total: int
