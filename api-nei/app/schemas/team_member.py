from pydantic import BaseModel, Field, AnyHttpUrl, constr

from typing import Optional
from typing_extensions import Annotated

from .team_role import TeamRoleInDB
from .user import UserInDB


class TeamMemberBase(BaseModel):
    mandate: constr(max_length=7)
    user_id: int
    role_id: int


class TeamMemberCreate(TeamMemberBase):
    """Properties to receive via API on creation."""
    pass


class TeamMemberUpdate(TeamMemberBase):
    """Properties to receive via API on creation."""
    mandate: Optional[constr(max_length=7)]
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
