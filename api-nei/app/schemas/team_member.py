from pydantic import BaseModel, Field, AnyHttpUrl, constr

from typing import Optional, List
from typing_extensions import Annotated

from .team_role import TeamRoleInDB
from .user import UserInDB
from .types import MandateStr



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
    mandate: Optional[MandateStr]
    user_id: Optional[int]
    role_id: Optional[int]


class TeamMemberInDB(TeamMemberBase):
    """Properties properties stored in DB."""
    id: int
    header: AnyHttpUrl
    user: UserInDB
    role: TeamRoleInDB

    class Config:
        orm_mode = True
