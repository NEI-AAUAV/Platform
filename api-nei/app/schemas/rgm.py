from datetime import datetime
from typing import Optional, Annotated

from pydantic import BaseModel, ConfigDict, StringConstraints
from .types import MandateStr


class RgmBase(BaseModel):
    category: Annotated[str, StringConstraints(max_length=3)]
    # Validate mandate to only allow 2020 or 2020/21
    mandate: Optional[MandateStr]
    # Real FK to RGM's own mandate calendar (rgm_mandate); `mandate` above
    # is the legacy free-text column, kept for compat. NOT NULL in the database.
    mandate_id: int
    file: Optional[str]
    date: Optional[datetime]
    title: Annotated[Optional[str], StringConstraints(max_length=264)]


class RgmCreate(RgmBase):
    """Properties to receive via API on create."""

    pass


class RgmUpdate(BaseModel):
    """Updates are not supported: any field is rejected."""

    model_config = ConfigDict(extra="forbid")


class RgmInDB(RgmBase):
    model_config = ConfigDict(from_attributes=True)

    id: int
    mandate: MandateStr


class RgmMandates(BaseModel):
    data: list[str]
