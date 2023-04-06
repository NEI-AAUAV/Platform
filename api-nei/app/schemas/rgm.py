from datetime import datetime
from typing import Optional

from pydantic import BaseModel, constr
from .types import MandateStr


class RgmBase(BaseModel):
    category: constr(max_length=3)
    # Validate mandate to only allow 2020 or 2020/21
    mandate: Optional[MandateStr]
    file: Optional[str]
    date: Optional[datetime]
    title: Optional[constr(max_length=264)]


class RgmCreate(RgmBase):
    """Properties to receive via API on create."""
    pass


class RgmUpdate():
    # Reject updates
    pass


class RgmInDB(RgmBase):
    id: int
    mandate: MandateStr

    class Config:
        orm_mode = True


class RgmMandates(BaseModel):
    data: list[str]
