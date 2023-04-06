from typing import Optional

from pydantic import AnyHttpUrl, BaseModel, constr, conint


class ParticipantBase(BaseModel):
    name: constr(max_length=50)


class ParticipantCreate(ParticipantBase):
    team_id: int
    pass


class ParticipantUpdate(ParticipantBase):
    name: Optional[constr(max_length=50)]


class Participant(ParticipantBase):
    id: int
    team_id: int
    image: Optional[AnyHttpUrl]

    class Config:
        orm_mode = True
