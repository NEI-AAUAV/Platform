from pydantic import BaseModel, Field

from typing import Optional
from typing_extensions import Annotated
from .tacaua_modality_details import TacaUAModalityDetailsBase


class TacaUAModalityBase(BaseModel):
    modality_details_id: int
    year: int
    division: int
    division_group: Annotated[Optional[str], Field(max_length=5)]
    image_url: Optional[str]


class TacaUAModalityCreate(TacaUAModalityBase):
    """Properties to receive via API on creation."""
    pass

class TacaUAModalityInDB(TacaUAModalityBase):
    """Properties properties stored in DB."""
    id: int

    class Config:
        orm_mode = True


class TacaUAModalityUpdate(TacaUAModalityInDB):
    """Properties to receive via API on update."""
    pass


class TacaUAModality(TacaUAModalityInDB):
    """Properties to return via API."""
    pass


class TacaUAModalityWithDetails(TacaUAModality, TacaUAModalityDetailsBase):
    """Properties to return via API."""
    pass
