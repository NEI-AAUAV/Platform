from pydantic import BaseModel, Field, HttpUrl

from typing import Optional
from typing_extensions import Annotated


class TacaUATeamBase(BaseModel):
    name: Annotated[Optional[str], Field(max_length=50)]
    image_url: Optional[HttpUrl]


class TacaUATeamCreate(TacaUATeamBase):
    """Properties to receive via API on creation."""
    name: Annotated[str, Field(max_length=50)]
    image_url: HttpUrl


class TacaUATeamUpdate():
    # Reject updates
    pass


class TacaUATeamInDB(TacaUATeamBase):
    """Properties properties stored in DB."""
    id: int

    class Config:
        orm_mode = True
