from datetime import datetime
from typing import Optional, Sequence
from pydantic import BaseModel

from .team import Team


class Match(BaseModel):
    team1_id: int
    team2_id: int
    goals1: Optional[int]
    goals2: Optional[int]
    date: datetime


class MatchInDB(Match):
    """Properties properties stored in DB."""
    id: int
    team1: Team
    team2: Team

    class Config:
        orm_mode = True

