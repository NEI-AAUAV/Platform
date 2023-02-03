from pydantic import BaseModel, Field

from typing import Optional
from typing_extensions import Annotated

from .user import UserInDB


class SeniorStudentBase(BaseModel):
    user_id: int
    quote: Annotated[Optional[str], Field(max_length=280)]
    image: Annotated[Optional[str], Field(max_length=255)]


class SeniorStudentCreate(SeniorStudentBase):
    """Properties to receive via API on creation."""
    user_id: int
    image: Annotated[str, Field(max_length=255)]


class SeniorStudentUpdate(SeniorStudentBase):
    """Properties to receive via API on update."""
    user_id: int


class SeniorStudentInDB(SeniorStudentBase):
    """Properties properties stored in DB."""
    user: UserInDB

    class Config:
        orm_mode = True
