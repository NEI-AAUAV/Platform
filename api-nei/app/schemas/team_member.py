from pydantic import BaseModel, Field

from typing import Optional
from typing_extensions import Annotated

from .team_role import TeamRoleInDB
from .user import UserInDB


class TeamMemberBase(BaseModel):
    header: Annotated[str, Field(max_length=256)]
    mandate: Optional[int]
    user_id: int
    role_id: int


class TeamMemberCreate(TeamMemberBase):
    """Properties to receive via API on creation."""
    pass


class TeamMemberUpdate(TeamMemberBase):
    """Properties to receive via API on creation."""
    header: Annotated[Optional[str], Field(max_length=256)]
    mandate: Optional[int]
    user_id: Optional[int]
    role_id: Optional[int]


class TeamMemberInDB(TeamMemberBase):
    """Properties properties stored in DB."""
    id: int
    user: UserInDB
    role: TeamRoleInDB

    class Config:
        orm_mode = True
