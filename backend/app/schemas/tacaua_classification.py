from pydantic import BaseModel, Field

from typing import Optional
from .tacaua_team import TacaUATeamInDB


class TacaUAClassificationBase(BaseModel):
    score: int = Field(default=0)
    games: int = Field(default=0)
    victories: int = Field(default=0)
    draws: int = Field(default=0)
    defeats: int = Field(default=0)
    g_scored: Optional[int] = None
    g_conceded: Optional[int] = None


class TacaUAClassificationCreate(TacaUAClassificationBase):
    """Properties to receive via API on create."""
    team_id: int
    modality_id: int
    pass


class TacaUAClassificationUpdate():
    # Reject updates
    pass
    

class TacaUAClassificationInDB(TacaUAClassificationBase):
    """Properties stored in DB."""
    team: TacaUATeamInDB

    class Config:
        orm_mode = True
