from pydantic import BaseModel, constr
from typing import List, Optional

from .round import Round
from .team import Team


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
    teams: List[Team]
   
    class Config:
        orm_mode = True
