from datetime import datetime
from typing import Literal, Optional, List

from pydantic import BaseModel
from .team import Team


class MatchCreate(BaseModel):
    round: int
    team1_id: Optional[int]
    team2_id: Optional[int]
    team1_prereq_match_id: Optional[int]
    team2_prereq_match_id: Optional[int]
    team1_is_prereq_match_winner: bool = True
    team2_is_prereq_match_winner: bool = True


class MatchUpdate(BaseModel):
    team1_id: Optional[int]
    team2_id: Optional[int]
    score1: Optional[int]
    score2: Optional[int]
    games1: List[int] = []
    games2: List[int] = []
    winner: Optional[Literal[0, 1, 2]]
    forfeiter: Optional[Literal[1, 2]]
    live: bool = False  # validate if its public # and has started obvs
    date: Optional[datetime]


class MatchLazy(MatchCreate, MatchUpdate):
    id: int

    class Config:
        orm_mode = True


class Match(MatchLazy):
    team1: Optional[Team]
    team2: Optional[Team]
