from datetime import date
from typing import Optional

from pydantic import BaseModel


class CourseBase(BaseModel):
    name: str
    code: str
    short: Optional[str]

class CourseCreate(CourseBase):
    """Properties to receive via API on create."""
    pass

class CourseUpdate():
    #Reject updates
    pass

class CourseInDB(CourseBase):

    class Config:
        orm_mode = True
