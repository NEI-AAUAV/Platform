from pydantic import BaseModel

from typing import Optional
from typing_extensions import Annotated

from .faina_roles import FainaRolesInDB
from .users import UsersInDB


class FainaMemberBase(BaseModel):
    member_id: int
    faina_id: int
    role_id: int


class FainaMemberCreate(FainaMemberBase):
    """Properties to receive via API on creation."""
    pass


class FainaMemberUpdate(FainaMemberBase):
    """Properties to receive via API on update."""
    member_id: Optional[int]
    role_id: Optional[int]


class FainaMemberInDB(FainaMemberBase):
    """Properties properties stored in DB."""
    id: int
    member: UsersInDB
    role: FainaRolesInDB

    class Config:
        orm_mode = True
