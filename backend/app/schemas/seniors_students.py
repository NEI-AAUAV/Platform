from pydantic import BaseModel, Field, HttpUrl

from typing import Optional
from typing_extensions import Annotated

from .seniors import SeniorsInDB


class SeniorsStudentsBase(BaseModel):
    #user_id: int
    quote: Annotated[str, Field(max_length=280)]
    image: Annotated[str, Field(max_length=255)]


class SeniorsStudentsCreate(SeniorsStudentsBase):
    """Properties to receive via API on creation."""
    year: int
    course: Annotated[str, Field(max_length=3)]
    #user_id: int
    quote: Annotated[str, Field(max_length=280)]
    image: Annotated[str, Field(max_length=255)]


class SeniorsStudentsUpdate(SeniorsStudentsBase):
    """Properties to receive via API on update."""
    #user_id: int
    quote: Annotated[Optional[str], Field(max_length=280)]
    image: Annotated[Optional[str], Field(max_length=255)]


class SeniorsStudentsInDB(SeniorsStudentsBase):
    """Properties properties stored in DB."""
    year: SeniorsInDB
    course: SeniorsInDB
    #user: 

    class Config:
        orm_mode = True
