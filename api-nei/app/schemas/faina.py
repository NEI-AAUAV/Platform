from pydantic import BaseModel, AnyHttpUrl

from typing import Optional, List
from .faina_member import FainaMemberInDB
from .types import MandateStr


class FainaBase(BaseModel):
    # Validate mandate to only allow 2020 or 2020/21
    mandate: MandateStr


class FainaCreate(FainaBase):
    """Properties to receive via API on creation."""
    pass


class FainaUpdate(FainaBase):
    """Properties to receive via API on update."""
    mandate: Optional[MandateStr]


class FainaInDB(FainaBase):
    """Properties properties stored in DB."""
    id: int
    image: Optional[AnyHttpUrl]
    members: List[FainaMemberInDB]

    class Config:
        orm_mode = True
