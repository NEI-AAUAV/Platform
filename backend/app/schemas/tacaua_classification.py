from pydantic import BaseModel, Field

from typing import Optional
from .tacaua_team import TacaUATeam


class TacaUAClassificationBase(BaseModel):
    score: int = Field(default=0)
    games: int = Field(default=0)
    victorie: int = Field(default=0)
    draw: int = Field(default=0)
    defeats: int = Field(default=0)
    g_scored: Optional[int]
    g_conceded: Optional[int]


class TacaUAClassificationInDB(TacaUAClassificationBase):
    """Properties properties stored in DB."""
    team_id: int
    modality_id: int

    class Config:
        orm_mode = True


class TacaUAClassification(TacaUAClassificationBase):
    """Properties to return via API."""
    team: TacaUATeam

