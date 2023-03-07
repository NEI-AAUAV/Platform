from pydantic import BaseModel, constr

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
    # Validate mandate to only allow 2020 or 2020/21
    mandate: Optional[constr(regex=r"^\d{4}(\/\d{2})?$")]


class TeamColaboratorInDB(TeamColaboratorBase):
    """Properties properties stored in DB."""
    user: UserInDB

    class Config:
        orm_mode = True
