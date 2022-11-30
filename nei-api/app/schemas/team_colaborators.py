from pydantic import BaseModel

from typing import Optional

from .users import UsersInDB


class TeamColaboratorsBase(BaseModel):
    user_id: int
    mandate: int


class TeamColaboratorsCreate(TeamColaboratorsBase):
    """Properties to receive via API on creation."""
    pass


class TeamColaboratorsUpdate(TeamColaboratorsBase):
    """Properties to receive via API on creation."""
    user_id: Optional[int]
    mandate: Optional[int]


class TeamColaboratorsInDB(TeamColaboratorsBase):
    """Properties properties stored in DB."""
    user: UsersInDB

    class Config:
        orm_mode = True
