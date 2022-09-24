from pydantic import BaseModel, constr, AnyHttpUrl
from typing import List, Optional

from app.utils import validate_to_json
from .participant import Participant
from .course import Course


class TeamBase(BaseModel):
    name: constr(max_length=50)


@validate_to_json
class TeamCreate(TeamBase):
    pass


@validate_to_json
class TeamUpdate(TeamBase):
    name: Optional[constr(max_length=50)]


class Team(TeamBase):
    id: int
    course_id: Course
    image: Optional[AnyHttpUrl]
    participants: List[Participant]

    class Config:
        orm_mode = True
