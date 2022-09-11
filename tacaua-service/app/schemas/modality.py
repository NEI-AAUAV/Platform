from typing import Optional
from pydantic import BaseModel, Field

from enum import Enum
from typing_extensions import Annotated


class TypeEnum(str, Enum):
    COLECTIVE = 'Coletiva'
    PAIRS = 'Pares'
    INDIVIDUAL = 'Individual'


class FrameEnum(str, Enum):
    MIXED = 'Misto'
    FEMININE = 'Feminino'
    MASCULINE = 'Masculino'


class SportEnum(str, Enum):
    ATHLETICS = 'Atletismo'
    HANDBALL = 'Andebol'
    BASKETBALL = 'Basquetebol'
    FUTSAL = 'Futsal'
    FOOTBALL = 'Futebol 7'
    VOLEYBALL = 'Voleibol 4x4'
    ESPORTS_LOL = 'E-Sports LOL'
    ESPORTS_CSGO = 'E-Sports CS:GO'

