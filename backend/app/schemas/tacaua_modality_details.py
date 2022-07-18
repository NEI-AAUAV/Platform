from typing import Optional
from pydantic import BaseModel, Field

from enum import Enum
from typing_extensions import Annotated


class TypeEnum(str, Enum):
    COLECTIVE = 'COLETIVA'
    INDIVIDUAL = 'INDIVIDUAL'


class GenderEnum(str, Enum):
    MIXED = 'MISTO'
    FEMININE = 'FEMININO'
    MASCULINE = 'MASCULINO'


class TacaUAModalityDetailsBase(BaseModel):
    name: Annotated[str, Field(max_length=30)]
    type: TypeEnum
    gender: GenderEnum


class TacaUAModalityDetailsInDB(TacaUAModalityDetailsBase):
    """Properties properties stored in DB."""
    id: int
    pts_victory: Optional[int]
    pts_draw: Optional[int]
    pts_defeat: Optional[int]

    class Config:
        orm_mode = True
