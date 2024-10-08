from pydantic import BaseModel, ConfigDict

from typing import Optional

from app.schemas.types import MandateStr
from app.schemas.user.user import AnonymousUserListing


class TeamColaboratorBase(BaseModel):
    user_id: int
    mandate: MandateStr


class TeamColaboratorCreate(TeamColaboratorBase):
    """Properties to receive via API on creation."""

    pass


class TeamColaboratorUpdate(TeamColaboratorBase):
    """Properties to receive via API on creation."""

    user_id: Optional[int]
    # Validate mandate to only allow 2020 or 2020/21
    mandate: Optional[MandateStr]


class TeamColaboratorInDB(TeamColaboratorBase):
    """Properties properties stored in DB."""

    model_config = ConfigDict(from_attributes=True)

    user: AnonymousUserListing
