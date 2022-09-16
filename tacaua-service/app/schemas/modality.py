from typing import Optional, List
from pydantic import BaseModel, FilePath
from pathlib import Path

from app.utils import EnumList
from typing_extensions import Annotated
from .competition import Competition


class TypeEnum(str, EnumList):
    COLECTIVE = 'Coletiva'
    PAIRS = 'Pares'
    INDIVIDUAL = 'Individual'


class FrameEnum(str, EnumList):
    MIXED = 'Misto'
    FEMININE = 'Feminino'
    MASCULINE = 'Masculino'


class SportEnum(str, EnumList):
    ATHLETICS = 'Atletismo'
    HANDBALL = 'Andebol'
    BASKETBALL = 'Basquetebol'
    FUTSAL = 'Futsal'
    FOOTBALL = 'Futebol 7'
    VOLEYBALL = 'Voleibol 4x4'
    ESPORTS_LOL = 'E-Sports LOL'
    ESPORTS_CSGO = 'E-Sports CS:GO'


# TODO: test if optional need to assign none

class ModalityBase(BaseModel):
    year: int
    frame: FrameEnum
    sport: SportEnum


class ModalityCreate(ModalityBase):
    image: Path


class ModalityUpdate(ModalityBase):
    year: Optional[int]
    frame: Optional[FrameEnum]
    sport: Optional[SportEnum]
    image: Optional[Path]


class Modality(ModalityBase):
    id: int
    image: Path # Change to path
    competitions: List[Competition]

    class Config:
        orm_mode = True


class ModalityList(BaseModel):
    modalities: List[Modality]
    types: List[TypeEnum] = TypeEnum.list()
    frames: List[FrameEnum] = FrameEnum.list()
    sports: List[SportEnum] = SportEnum.list()
