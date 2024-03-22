from datetime import datetime
from typing import Optional, Annotated

from pydantic import BaseModel, ConfigDict, StringConstraints
from .types import MandateStr


class RgmBase(BaseModel):
    category: Annotated[str, StringConstraints(max_length=3)]
    # Validate mandate to only allow 2020 or 2020/21
    mandate: Optional[MandateStr]
    file: Optional[str]
    date: Optional[datetime]
    title: Annotated[Optional[str], StringConstraints(max_length=264)]


class RgmCreate(RgmBase):
    """Properties to receive via API on create."""

    pass


class RgmUpdate:
    # Reject updates
    pass


class RgmInDB(RgmBase):
    model_config = ConfigDict(from_attributes=True)

    id: int
    mandate: MandateStr


class RgmMandates(BaseModel):
    data: list[str]
