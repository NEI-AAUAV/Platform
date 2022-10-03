from typing import Optional, List

from pydantic import BaseModel, constr

from .match import Match


class RoundBase(BaseModel):
    number: int
    name: Optional[constr(max_length=20)]


class RoundCreate(RoundBase):
    pass


# class RoundUpdate():
#     pass


class Round(RoundBase):
    id: int
    matches: List[Match]

    class Config:
        orm_mode = True
