from pydantic import BaseModel, Field, HttpUrl

from typing import Optional
from typing_extensions import Annotated


class SeniorsBase(BaseModel):
    year: int
    course: Annotated[str, Field(max_length=3)]
    image: Annotated[str, Field(max_length=255)]


class SeniorsCreate(SeniorsBase):
    """Properties to receive via API on creation."""
    pass


class SeniorsUpdate(SeniorsBase):
    """Properties to receive via API on update."""
    year: int
    course: Annotated[str, Field(max_length=3)]
    image: Annotated[Optional[str], Field(max_length=255)]


class SeniorsInDB(SeniorsBase):
    """Properties properties stored in DB."""
    year: int
    course: Annotated[str, Field(max_length=3)]

    class Config:
        orm_mode = True
