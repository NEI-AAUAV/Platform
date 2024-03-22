from pydantic import BaseModel, Field, ConfigDict

from typing import Optional, Annotated


class TeamRoleBase(BaseModel):
    name: Annotated[str, Field(max_length=120)]
    weight: int


class TeamRoleCreate(TeamRoleBase):
    """Properties to receive via API on creation."""

    pass


class TeamRoleUpdate(TeamRoleBase):
    """Properties to receive via API on creation."""

    name: Annotated[Optional[str], Field(max_length=120)]
    weight: Optional[int]


class TeamRoleInDB(TeamRoleBase):
    """Properties properties stored in DB."""

    model_config = ConfigDict(from_attributes=True)

    id: int
