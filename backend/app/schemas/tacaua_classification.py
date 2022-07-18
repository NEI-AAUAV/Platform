from pydantic import BaseModel

from typing import Optional
from .tacaua_team import TacaUATeamInDB


class TacaUAClassificationBase(BaseModel):
    team_id: int
    modality_id: int
    score: int = 0  # does not allow None
    games: int = 0
    victories: int = 0
    draws: int = 0
    defeats: int = 0
    g_scored: Optional[int]
    g_conceded: Optional[int]


class TacaUAClassificationCreate(TacaUAClassificationBase):
    """Properties to receive via API on create."""
    pass


class TacaUAClassificationUpdate():
    # Reject updates
    pass
    

class TacaUAClassificationInDB(TacaUAClassificationBase):
    """Properties stored in DB."""
    team: TacaUATeamInDB

    class Config:
        orm_mode = True
