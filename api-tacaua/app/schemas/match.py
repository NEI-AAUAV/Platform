from datetime import datetime
from typing import Literal, Optional, List

from pydantic import BaseModel, ConfigDict
from .team import Team


class MatchCreate(BaseModel):
    round: int
    team1_id: Optional[int]
    team2_id: Optional[int]
    team1_prereq_match_id: Optional[int]
    team2_prereq_match_id: Optional[int]
    team1_is_prereq_match_winner: Optional[bool] = True  # remove optional perhaps
    team2_is_prereq_match_winner: Optional[bool] = True  # remove optional perhaps


class MatchUpdate(BaseModel):
    team1_id: Optional[int] = None
    team2_id: Optional[int] = None
    score1: Optional[int] = None
    score2: Optional[int] = None
    games1: List[int] = []
    games2: List[int] = []
    winner: Optional[Literal[0, 1, 2]] = None
    forfeiter: Optional[Literal[1, 2]] = None
    live: bool = False  # validate if its public # and has started obvs
    date: Optional[datetime] = None


class MatchLazy(MatchCreate, MatchUpdate):
    model_config = ConfigDict(from_attributes=True)

    id: int


class Match(MatchLazy):
    team1: Optional[Team]
    team2: Optional[Team]


class MatchList(BaseModel):
    data: List[Match]
