from pydantic import BaseModel, Field, HttpUrl

from typing import Optional
from typing_extensions import Annotated


class FainaRolesBase(BaseModel):
    name: Annotated[str, Field(max_length=20)]
    weight: Optional[int]


class FainaRolesCreate(FainaRolesBase):
    """Properties to receive via API on creation."""
    name: Annotated[str, Field(max_length=20)]
    weight: Optional[int]


#class TacaUATeamUpdate():
    # Reject updates
#    pass


class FainaRolesInDB(FainaRolesBase):
    """Properties properties stored in DB."""
    id: int

    class Config:
        orm_mode = True
