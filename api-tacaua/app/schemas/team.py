from typing import Annotated, List, Optional

from pydantic import BaseModel, ConfigDict, StringConstraints, AnyHttpUrl

from app.utils import ValidateFromJson
from .participant import Participant
from .course import Course


class TeamBase(BaseModel):
    name: Optional[Annotated[str, StringConstraints(max_length=50)]] = None
    course_id: int


class TeamCreate(TeamBase, ValidateFromJson):
    modality_id: int


class TeamUpdate(TeamBase, ValidateFromJson):
    course_id: Optional[int] = None


class TeamLazy(TeamBase):
    model_config = ConfigDict(from_attributes=True)

    id: int


class Team(TeamLazy):
    modality_id: int
    image: Optional[AnyHttpUrl]
    course: Course
    participants: List[Participant]
