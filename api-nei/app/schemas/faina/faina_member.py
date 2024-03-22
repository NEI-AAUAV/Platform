from pydantic import BaseModel, ConfigDict

from app.schemas.user.user import AnonymousUserListing
from app.utils import optional
from .faina_role import FainaRoleInDB


class FainaMemberBase(BaseModel):
    member_id: int
    faina_id: int
    role_id: int


class FainaMemberCreate(FainaMemberBase):
    """Properties to receive via API on creation."""

    ...


@optional()
class FainaMemberUpdate(FainaMemberBase):
    """Properties to receive via API on update."""

    ...


class FainaMemberInDB(BaseModel):
    """Properties properties stored in DB."""

    model_config = ConfigDict(from_attributes=True)

    id: int
    faina_id: int
    role: FainaRoleInDB
    member: AnonymousUserListing
