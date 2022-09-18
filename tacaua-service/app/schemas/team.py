from pathlib import Path
from pydantic import BaseModel, constr
from typing import List

from app.utils import schema_as_form
from .participant import Participant


class TeamBase(BaseModel):
    name: constr(max_length=50)


@schema_as_form
class TeamCreate(TeamBase):
    pass

@schema_as_form
class TeamUpdate(TeamBase):
    name: constr(max_length=50)


class Team(TeamBase):
    id: int
    image: Path
    participants: List[Participant]

    class Config:
        orm_mode = True
