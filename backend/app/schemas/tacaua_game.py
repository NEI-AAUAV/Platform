from datetime import datetime
from typing import Optional, Sequence
from pydantic import BaseModel

from .tacaua_team import TacaUATeamInDB


class TacaUAGameBase(BaseModel):
    team1_id: Optional[int]
    team2_id: Optional[int]
    goals1: Optional[int]
    goals2: Optional[int]
    date: Optional[datetime]


class TacaUAGameCreate(TacaUAGameBase):
    """Properties to receive via API on creation."""
    team1_id: int
    team2_id: int
    date: datetime


class TacaUAGameUpdate(TacaUAGameBase):
    """Properties to receive via API on update."""
    pass


class TacaUAGameInDB(TacaUAGameBase):
    """Properties properties stored in DB."""
    id: int
    team1: TacaUATeamInDB
    team2: TacaUATeamInDB

    class Config:
        orm_mode = True


class TacaUAGameResults(BaseModel):
    results: Sequence[TacaUAGameInDB]
