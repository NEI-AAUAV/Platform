from pydantic import BaseModel, constr, conint
from typing import Optional



class ParticipantBase(BaseModel):
    name: constr(max_length=50)
    number: conint(ge=1, le=99)


class ParticipantCreate(ParticipantBase):
    team_id: int
    pass


class ParticipantUpdate(ParticipantBase):
    name: Optional[constr(max_length=50)]
    number: Optional[conint(ge=1, le=99)]


class Participant(ParticipantBase):
    id: int

    class Config:
        orm_mode = True
