from pydantic import BaseModel, ConfigDict
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
    match_history: list[Literal[-1, 0, 1]] = []



class StandingsCreate(StandingsBase):
    pass


class StandingsUpdate(StandingsBase):
    pass


class StandingsInDB(StandingsBase):
    model_config = ConfigDict(from_attributes=True)

    id: int
    team: TeamLazy



class StandingGroupTeam(BaseModel):
    team_id: int


class StandingsTable(BaseModel):
    auto: bool
    table: List[StandingsInDB]
