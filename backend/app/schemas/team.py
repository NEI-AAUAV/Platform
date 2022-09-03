from pydantic import BaseModel, Field, HttpUrl

from typing import Optional
from typing_extensions import Annotated

from .team_roles import TeamRolesInDB


class TeamBase(BaseModel):
    header: Annotated[str, Field(max_length=255)]
    mandato: Optional[int]
    #user_id: int
    role_id: int


class TeamCreate(TeamBase):
    """Properties to receive via API on creation."""
    pass


class TeamUpdate(TeamBase):
    """Properties to receive via API on creation."""
    header: Annotated[Optional[str], Field(max_length=255)]
    mandato: Optional[int]
    #user_id: Optional[int]
    role_id: Optional[int]


class TeamInDB(TeamBase):
    """Properties properties stored in DB."""
    id: int
    #user:
    role: TeamRolesInDB

    class Config:
        orm_mode = True
