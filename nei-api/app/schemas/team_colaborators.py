from re import U
from pydantic import BaseModel, Field, HttpUrl

from typing import Optional
from typing_extensions import Annotated

from .users import UsersInDB


class TeamColaboratorsBase(BaseModel):
    colaborator_id: int
    mandato: int


class TeamColaboratorsCreate(TeamColaboratorsBase):
    """Properties to receive via API on creation."""
    pass


class TeamColaboratorsUpdate(TeamColaboratorsBase):
    """Properties to receive via API on creation."""
    colaborator_id: Optional[int]
    mandato: Optional[int]


class TeamColaboratorsInDB(TeamColaboratorsBase):
    """Properties properties stored in DB."""
    colaborator: UsersInDB

    class Config:
        orm_mode = True
