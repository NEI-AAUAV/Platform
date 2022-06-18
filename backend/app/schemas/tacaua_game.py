from datetime import datetime
from pydantic import BaseModel

from .tacaua_team import TacaUATeam


class TacaUAGameBase(BaseModel):
    team1_id: int
    team2_id: int
    goals1: int
    goals2: int
    date: datetime


class TacaUAGameCreate(TacaUAGameBase):
    """Properties to receive via API on creation."""
    pass


class TacaUAGameInDB(TacaUAGameBase):
    """Properties properties stored in DB."""
    id: int

    class Config:
        orm_mode = True


class TacaUAGameUpdate(TacaUAGameInDB):
    """Properties to receive via API on update."""
    pass


class TacaUAGame(TacaUAGameInDB):
    """Properties to return via API."""
    team1: TacaUATeam
    team2: TacaUATeam
