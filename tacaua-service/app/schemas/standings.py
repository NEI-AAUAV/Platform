from pydantic import BaseModel, Field

from typing import Optional
from typing_extensions import Annotated
from .match import Match


class Standings(BaseModel):
    pts: int
    matches: int
    wins: int
    ties: int
    losses: int
    ff: int
    score_for: int
    score_agst: int
    score_diff: int
    math_history: list[Match]
