from typing import Optional

from pydantic import BaseModel
from .types import MandateStr



class RgmBase(BaseModel):
    category: str
    # Validate mandate to only allow 2020 or 2020/21
    mandate: Optional[MandateStr]
    file: Optional[str]


class RgmCreate(RgmBase):
    """Properties to receive via API on create."""
    pass


class RgmUpdate():
    #Reject updates
    pass


class RgmInDB(RgmBase):
    id: int
    mandate: MandateStr

    class Config:
        orm_mode = True
