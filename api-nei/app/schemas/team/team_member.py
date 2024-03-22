from typing import Optional, List

from pydantic import BaseModel, AnyHttpUrl, ConfigDict

from .team_role import TeamRoleInDB
from app.schemas.types import MandateStr
from app.schemas.user.user import AnonymousUserListing


class TeamMemberBase(BaseModel):
    # Validate mandate to only allow 2020 or 2020/21
    mandate: MandateStr
    user_id: int
    role_id: int


class TeamMandates(BaseModel):
    data: List[str]


class TeamMemberCreate(TeamMemberBase):
    """Properties to receive via API on creation."""

    pass


class TeamMemberUpdate(TeamMemberBase):
    """Properties to receive via API on creation."""

    mandate: Optional[MandateStr] = None
    user_id: Optional[int] = None
    role_id: Optional[int] = None


class TeamMemberInDB(TeamMemberBase):
    """Properties properties stored in DB."""

    model_config = ConfigDict(from_attributes=True)

    id: int
    header: Optional[AnyHttpUrl]
    user: AnonymousUserListing
    role: TeamRoleInDB
