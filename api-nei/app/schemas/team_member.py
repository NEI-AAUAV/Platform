from pydantic import BaseModel, Field, AnyHttpUrl, constr

from typing import Optional
from typing_extensions import Annotated

from .team_role import TeamRoleInDB
from .user import UserInDB


class TeamMemberBase(BaseModel):
    # Validate mandate to only allow 2020 or 2020/21
    mandate: constr(regex=r"^\d{4}(\/\d{2})?$")
    user_id: int
    role_id: int


class TeamMemberCreate(TeamMemberBase):
    """Properties to receive via API on creation."""
    pass


class TeamMemberUpdate(TeamMemberBase):
    """Properties to receive via API on creation."""
    mandate: Optional[constr(regex=r"^\d{4}(\/\d{2})?$")]
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
