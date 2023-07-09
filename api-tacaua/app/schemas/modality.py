from typing import Optional, List

from pydantic import BaseModel, AnyHttpUrl

from app.utils import EnumList, validate_to_json
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


class ModalityBase(BaseModel):
    year: int
    type: TypeEnum
    frame: FrameEnum
    sport: SportEnum


@validate_to_json
class ModalityCreate(ModalityBase):
    pass


@validate_to_json
class ModalityUpdate(ModalityBase):
    year: Optional[int]
    type: Optional[TypeEnum]
    frame: Optional[FrameEnum]
    sport: Optional[SportEnum]


class ModalityLazy(ModalityBase):
    id: int

    class Config:
        orm_mode = True


class Modality(ModalityLazy):
    competitions: List[Competition]
    teams: List[Team]


class ModalityLazyList(BaseModel):
    modalities: List[ModalityLazy]
    types: List[TypeEnum] = TypeEnum.list()
    frames: List[FrameEnum] = FrameEnum.list()
    sports: List[SportEnum] = SportEnum.list()
