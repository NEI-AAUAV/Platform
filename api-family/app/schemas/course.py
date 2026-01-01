"""
Course schemas for Family API.
"""

from typing import Optional
from pydantic import BaseModel, Field, constr


class CourseBase(BaseModel):
    """Base course schema with common fields."""
    short: constr(max_length=8) = Field(..., description="Course abbreviation (e.g., LEI, MEI)")
    name: str = Field(..., description="Full course name")
    degree: str = Field(..., description="Degree type (Licenciatura, Mestrado, Programa Doutoral)")
    show: Optional[bool] = Field(default=False, description="Whether to show in UI")


class CourseCreate(CourseBase):
    """Schema for creating a new course."""
    pass


class CourseUpdate(BaseModel):
    """Schema for updating a course. All fields optional."""
    short: Optional[constr(max_length=8)] = None
    name: Optional[str] = None
    degree: Optional[str] = None
    show: Optional[bool] = None


class CourseInDB(CourseBase):
    """Course as stored in database."""
    id: int = Field(..., alias="_id")
    
    class Config:
        orm_mode = True
        allow_population_by_field_name = True


class CourseList(BaseModel):
    """Paginated list of courses."""
    items: list[CourseInDB]
    total: int
    skip: int
    limit: int
