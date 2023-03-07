from pydantic import BaseModel, AnyHttpUrl, constr

from typing import Optional, List
from .faina_member import FainaMemberInDB


class FainaBase(BaseModel):
    # Validate mandate to only allow 2020 or 2020/21
    mandate: constr(regex=r"^\d{4}(\/\d{2})?$")


class FainaCreate(FainaBase):
    """Properties to receive via API on creation."""
    pass


class FainaUpdate(FainaBase):
    """Properties to receive via API on update."""
    mandate: Optional[constr(regex=r"^\d{4}(\/\d{2})?$")]


class FainaInDB(FainaBase):
    """Properties properties stored in DB."""
    id: int
    image: Optional[AnyHttpUrl]
    members: List[FainaMemberInDB]

    class Config:
        orm_mode = True
