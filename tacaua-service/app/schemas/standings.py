from pydantic import BaseModel, Field
from typing import List

from typing import Optional
from typing_extensions import Annotated
from .match import Match


class StandingsRow(BaseModel):
    pts: int
    matches: int
    wins: int
    ties: int
    losses: int
    ff: int
    score_for: int
    score_agst: int
    score_diff: int
    math_history: List[Match]


class Standings(BaseModel):
    standings: List[StandingsRow]
