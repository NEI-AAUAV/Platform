from pydantic import BaseModel, Field

from typing import Optional
from typing_extensions import Annotated
from .tacaua_modality_details import TacaUAModalityDetailsInDB


class TacaUAModalityBase(BaseModel):
    modality_details_id: Optional[int]
    year: Optional[int]
    division: Optional[int]
    division_group: Annotated[Optional[str], Field(max_length=5)]
    image_url: Optional[str]


class TacaUAModalityCreate(TacaUAModalityBase):
    """Properties to receive via API on creation."""
    modality_details_id: int
    year: int
    division: int


class TacaUAModalityUpdate(TacaUAModalityBase):
    """Properties to receive via API on update."""
    pass


class TacaUAModalityInDB(TacaUAModalityBase):
    """Properties properties stored in DB."""
    id: int
    modality_details: TacaUAModalityDetailsInDB

    class Config:
        orm_mode = True
