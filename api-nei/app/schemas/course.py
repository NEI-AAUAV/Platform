from typing import Optional

from pydantic import BaseModel, ConfigDict


class CourseBase(BaseModel):
    name: str
    code: str
    short: Optional[str]


class CourseCreate(CourseBase):
    """Properties to receive via API on create."""

    pass


class CourseUpdate(BaseModel):
    """Updates are not supported: any field is rejected."""

    model_config = ConfigDict(extra="forbid")


class CourseInDB(CourseBase):
    model_config = ConfigDict(from_attributes=True)
