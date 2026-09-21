from typing import Optional

from pydantic import BaseModel, AnyHttpUrl, ConfigDict

from app.schemas.types import ShortNameStr
from app.schemas.user.user import AnonymousUserListing


class TeamMemberBase(BaseModel):
    section_id: int
    user_id: Optional[int] = None
    name: ShortNameStr
    role: ShortNameStr
    weight: int = 0


class TeamMemberCreate(TeamMemberBase):
    """Properties to receive via API on creation."""

    pass


class TeamMemberUpdate(BaseModel):
    """Properties to receive via API on update."""

    section_id: Optional[int] = None
    user_id: Optional[int] = None
    name: Optional[ShortNameStr] = None
    role: Optional[ShortNameStr] = None
    weight: Optional[int] = None


class TeamMemberInDB(TeamMemberBase):
    """Properties properties stored in DB."""

    model_config = ConfigDict(from_attributes=True)

    id: int
    header: Optional[AnyHttpUrl] = None
    user: Optional[AnonymousUserListing] = None
