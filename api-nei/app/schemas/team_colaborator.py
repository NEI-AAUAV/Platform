from pydantic import BaseModel

from typing import Optional

from .user import UserInDB


class TeamColaboratorBase(BaseModel):
    user_id: int
    mandate: int


class TeamColaboratorCreate(TeamColaboratorBase):
    """Properties to receive via API on creation."""
    pass


class TeamColaboratorUpdate(TeamColaboratorBase):
    """Properties to receive via API on creation."""
    user_id: Optional[int]
    mandate: Optional[int]


class TeamColaboratorInDB(TeamColaboratorBase):
    """Properties properties stored in DB."""
    user: UserInDB

    class Config:
        orm_mode = True
