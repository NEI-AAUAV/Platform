from typing import List, Optional

from pydantic import BaseModel, constr, AnyHttpUrl

from app.utils import validate_to_json
from .participant import Participant
from .course import Course


class TeamBase(BaseModel):
    name: Optional[constr(max_length=50)]
    course_id: int


@validate_to_json
class TeamCreate(TeamBase):
    modality_id: int
    pass


@validate_to_json
class TeamUpdate(TeamBase):
    course_id: Optional[int]


class TeamLazy(TeamBase):
    id: int

    class Config:
        orm_mode = True


class Team(TeamLazy):
    modality_id: int
    image: Optional[AnyHttpUrl]
    course: Course
    participants: List[Participant]
