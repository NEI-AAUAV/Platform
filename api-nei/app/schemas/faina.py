from pydantic import BaseModel, Field

from typing import Optional, List
from typing_extensions import Annotated
from .faina_member import FainaMemberInDB


class FainaBase(BaseModel):
    image: Annotated[Optional[str], Field(max_length=256)]
    year: Annotated[str, Field(max_length=9)]


class FainaCreate(FainaBase):
    """Properties to receive via API on creation."""
    pass


class FainaUpdate(FainaBase):
    """Properties to receive via API on update."""
    year: Annotated[Optional[str], Field(max_length=9)]


class FainaInDB(FainaBase):
    """Properties properties stored in DB."""
    id: int
    members: List[FainaMemberInDB]

    class Config:
        orm_mode = True
