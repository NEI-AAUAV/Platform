from pydantic import BaseModel, Field, HttpUrl

from typing import Optional
from typing_extensions import Annotated


class TeamRolesBase(BaseModel):
    name: Annotated[str, Field(max_length=120)]
    weight: int


class TeamRolesCreate(TeamRolesBase):
    """Properties to receive via API on creation."""
    pass


class TeamRolesUpdate(TeamRolesBase):
    """Properties to receive via API on creation."""
    name: Annotated[Optional[str], Field(max_length=120)]
    weight: Optional[int]


class TeamRolesInDB(TeamRolesBase):
    """Properties properties stored in DB."""
    id: int

    class Config:
        orm_mode = True
