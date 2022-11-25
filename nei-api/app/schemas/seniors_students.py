from pydantic import BaseModel, Field

from typing import Optional
from typing_extensions import Annotated

from .users import UsersInDB


class SeniorsStudentsBase(BaseModel):
    user_id: int
    quote: Annotated[Optional[str], Field(max_length=280)]
    image: Annotated[Optional[str], Field(max_length=255)]


class SeniorsStudentsCreate(SeniorsStudentsBase):
    """Properties to receive via API on creation."""
    year: int
    course: Annotated[str, Field(max_length=3)]
    user_id: int
    image: Annotated[str, Field(max_length=255)]


class SeniorsStudentsUpdate(SeniorsStudentsBase):
    """Properties to receive via API on update."""
    user_id: int


class SeniorsStudentsInDB(SeniorsStudentsBase):
    """Properties properties stored in DB."""
    year: int
    course: str
    user: UsersInDB

    class Config:
        orm_mode = True
