from typing import Annotated, List, Optional, Set

from pydantic import BaseModel, ConfigDict, StringConstraints

from .match import Match
from .team import TeamLazy


class GroupBase(BaseModel):
    name: Optional[Annotated[str, StringConstraints(max_length=20)]] = None


class GroupCreate(BaseModel):
    competition_id: int


class GroupUpdate(BaseModel):
    number: Optional[int] = None
    teams_id: Set[int] = set()


class Group(GroupBase):
    model_config = ConfigDict(from_attributes=True)

    id: int
    competition_id: int
    number: int
    matches: List[Match]
    teams: List[TeamLazy]
