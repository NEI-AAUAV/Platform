from pydantic import BaseModel
from typing import Literal, List
from .team import TeamLazy

class StandingsBase(BaseModel):
    team_id: int
    group_id: int
    pts: int = 0
    matches: int = 0
    wins: int = 0
    ties: int = 0
    losses: int = 0
    ff: int = 0
    score_for: int = 0
    score_agst: int = 0
    goal_difference: int = 0
    math_history: list[Literal[-1, 0, 1]] = []

class StandingsCreate(StandingsBase):
    pass

class StandingsUpdate(StandingsBase):
    pass

class StandingsInDB(StandingsBase):
    id: int
    team: TeamLazy

    class Config:
        orm_mode = True

class StandingGroupTeam(BaseModel):
    team_id: int

class StandingsTable(BaseModel):
    auto: bool
    table: List[StandingsInDB]
