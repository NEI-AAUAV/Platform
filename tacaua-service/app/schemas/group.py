from typing import List, Optional

from pydantic import BaseModel, constr

from .round import Round
from .team import TeamLazy


class GroupBase(BaseModel):
    number: Optional[int]
    name: Optional[constr(max_length=20)]


class GroupCreate():
    pass


class GroupUpdate():
    pass


class Group(GroupBase):
    """Properties properties stored in DB."""
    id: int
    rounds: List[Round]
    teams: List[TeamLazy]
   
    class Config:
        orm_mode = True
