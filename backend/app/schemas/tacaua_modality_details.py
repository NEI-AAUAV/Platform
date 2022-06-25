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
    pts_victory: int = Field(default=0)
    pts_draw: int = Field(default=0)
    pts_defeat: int = Field(default=0)

    class Config:
        orm_mode = True
