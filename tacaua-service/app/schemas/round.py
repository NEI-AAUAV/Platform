from pydantic import BaseModel, Field

from typing import Optional
from typing_extensions import Annotated


class Round(BaseModel):
    year: Optional[int]
    division: Optional[int]
    division_group: Annotated[Optional[str], Field(max_length=5)]
    image_url: Optional[str]


class RoundUpdate(Round):
    """Properties to receive via API on update."""
    pass


class RoundInDB(Round):
    """Properties properties stored in DB."""
    id: int

    class Config:
        orm_mode = True
