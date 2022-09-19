from typing import Optional, List
from pydantic import BaseModel, AnyHttpUrl

from app.utils import EnumList, schema_as_form
from app.core.logging import logger
from .competition import Competition
from .team import Team


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


@schema_as_form
class ModalityCreate(ModalityBase):
    pass


@schema_as_form
class ModalityUpdate(ModalityBase):
    year: Optional[int]
    frame: Optional[FrameEnum]
    sport: Optional[SportEnum]


class ModalityInDBBase(ModalityBase):
    id: int
    image: AnyHttpUrl

    class Config:
        orm_mode = True


class Modality(ModalityInDBBase):
    competitions: List[Competition]
    teams: List[Team]


class LazyModality(ModalityInDBBase):
    pass


class LazyModalityList(BaseModel):
    modalities: List[LazyModality]
    types: List[TypeEnum] = TypeEnum.list()
    frames: List[FrameEnum] = FrameEnum.list()
    sports: List[SportEnum] = SportEnum.list()
