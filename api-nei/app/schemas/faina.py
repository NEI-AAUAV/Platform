from pydantic import BaseModel, AnyHttpUrl, constr

from typing import Optional, List
from .faina_member import FainaMemberInDB


class FainaBase(BaseModel):
    year: constr(max_length=7)


class FainaCreate(FainaBase):
    """Properties to receive via API on creation."""
    pass


class FainaUpdate(FainaBase):
    """Properties to receive via API on update."""
    year: Optional[constr(max_length=7)]


class FainaInDB(FainaBase):
    """Properties properties stored in DB."""
    id: int
    image: AnyHttpUrl
    members: List[FainaMemberInDB]

    class Config:
        orm_mode = True
