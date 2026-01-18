"""
Simplified User schemas for Family Tree API.
Matches the new flat MongoDB structure.
"""

from typing import Optional, Literal, List
from pydantic import BaseModel, Field


class UserBase(BaseModel):
    """Base user model with required and optional fields."""
    name: str = Field(..., max_length=100)
    sex: Literal['M', 'F']
    start_year: Optional[int] = Field(None, ge=0, le=99, description="Year of entry (0-99)")
    nmec: Optional[int] = Field(None, description="Número mecanográfico")
    faina_name: Optional[str] = Field(None, max_length=50, description="Nome de faina")
    course_id: Optional[int] = Field(None, description="Course ID for other courses")
    patrao_id: Optional[int] = Field(None, description="Patrão user ID (null for roots)")
    end_year: Optional[int] = Field(None, ge=0, le=99, description="Year of end (0-99)")


class UserCreate(UserBase):
    """Schema for creating a new user."""
    pass


class UserUpdate(BaseModel):
    """Schema for updating a user. All fields optional."""
    name: Optional[str] = Field(None, max_length=100)
    sex: Optional[Literal['M', 'F']] = None
    start_year: Optional[int] = Field(None, ge=0, le=99)
    nmec: Optional[int] = None
    faina_name: Optional[str] = Field(None, max_length=50)
    course_id: Optional[int] = None
    patrao_id: Optional[int] = None
    end_year: Optional[int] = Field(None, ge=0, le=99)


class UserInDB(UserBase):
    """Schema for user response from database."""
    id: int = Field(..., alias="_id")
    user_roles: Optional[List[dict]] = []

    class Config:
        orm_mode = True
        allow_population_by_field_name = True


class UserList(BaseModel):
    """Schema for paginated user list response."""
    items: List[UserInDB]
    total: int
    skip: int
    limit: int


class UserBulkCreate(BaseModel):
    """Schema for creating a user in bulk. start_year is required here."""
    name: str = Field(..., max_length=100)
    sex: Literal['M', 'F']
    start_year: int = Field(..., ge=0, le=99, description="Year of entry (0-99) - REQUIRED for bulk")
    nmec: Optional[int] = Field(None, description="Número mecanográfico")
    faina_name: Optional[str] = Field(None, max_length=50, description="Nome de faina")
    course_id: Optional[int] = Field(None, description="Course ID for other courses")
    patrao_id: Optional[int] = Field(None, description="Patrão user ID (null for roots)")


class BulkCreateError(BaseModel):
    """Error for a single row in bulk create."""
    row: int  # 0-indexed row number
    data: dict  # The original row data
    message: str  # Error description


class BulkCreateResponse(BaseModel):
    """Response for bulk create operation."""
    created: List[UserInDB]  # Successfully created users
    errors: List[BulkCreateError]  # Failed rows with details
    warnings: List[str] = []  # Non-blocking warnings (e.g., duplicate names)
    total_submitted: int
    total_created: int
    total_errors: int
    dry_run: bool = False  # True if this was a dry-run (no actual changes)

