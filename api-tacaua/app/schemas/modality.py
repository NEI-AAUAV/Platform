from typing import Optional, List

from pydantic import BaseModel, ConfigDict

from app.utils import EnumList, ValidateFromJson
from .competition import Competition
from .team import Team


class TypeEnum(str, EnumList):
    COLECTIVE = "Coletiva"
    PAIRS = "Pares"
    INDIVIDUAL = "Individual"


class FrameEnum(str, EnumList):
    MIXED = "Misto"
    FEMININE = "Feminino"
    MASCULINE = "Masculino"


class SportEnum(str, EnumList):
    ATHLETICS = "Atletismo"
    HANDBALL = "Andebol"
    BASKETBALL = "Basquetebol"
    FUTSAL = "Futsal"
    FOOTBALL = "Futebol 7"
    VOLEYBALL = "Voleibol 4x4"
    ESPORTS_LOL = "E-Sports LOL"
    ESPORTS_CSGO = "E-Sports CS:GO"


class ModalityBase(BaseModel):
    year: int
    type: TypeEnum
    frame: FrameEnum
    sport: SportEnum


class ModalityCreate(ModalityBase, ValidateFromJson):
    ...


class ModalityUpdate(ModalityBase, ValidateFromJson):
    year: Optional[int] = None
    type: Optional[TypeEnum] = None
    frame: Optional[FrameEnum] = None
    sport: Optional[SportEnum] = None


class ModalityLazy(ModalityBase):
    model_config = ConfigDict(from_attributes=True)

    id: int


class Modality(ModalityLazy):
    competitions: List[Competition]
    teams: List[Team]


class ModalityLazyList(BaseModel):
    modalities: List[ModalityLazy]
    types: List[TypeEnum] = TypeEnum.list()
    frames: List[FrameEnum] = FrameEnum.list()
    sports: List[SportEnum] = SportEnum.list()
