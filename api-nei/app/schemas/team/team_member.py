from typing import Optional

from pydantic import BaseModel, AnyHttpUrl, ConfigDict

from app.schemas.user.user import AnonymousUserListing


class TeamMemberBase(BaseModel):
    section_id: int
    user_id: Optional[int] = None
    name: str
    role: str
    weight: int = 0
    # Denormalized from section_id's mandate — see the TeamMember model.
    mandate: Optional[str] = None


class TeamMemberCreate(TeamMemberBase):
    """Properties to receive via API on creation."""

    pass


class TeamMemberUpdate(BaseModel):
    """Properties to receive via API on update."""

    section_id: Optional[int] = None
    user_id: Optional[int] = None
    name: Optional[str] = None
    role: Optional[str] = None
    weight: Optional[int] = None
    mandate: Optional[str] = None


class TeamMemberInDB(TeamMemberBase):
    """Properties properties stored in DB."""

    model_config = ConfigDict(from_attributes=True)

    id: int
    header: Optional[AnyHttpUrl] = None
    user: Optional[AnonymousUserListing] = None
