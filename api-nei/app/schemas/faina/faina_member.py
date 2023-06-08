from pydantic import BaseModel

from typing import Optional
from typing_extensions import Annotated

from .faina_role import FainaRoleInDB
from app.schemas.user import UserInDB


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
    member: UserInDB
    role: FainaRoleInDB

    class Config:
        orm_mode = True
