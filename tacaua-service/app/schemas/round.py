from pydantic import BaseModel, constr

from typing import Optional


class RoundBase(BaseModel):
    number: int
    name: Optional[constr(max_length=20)]


class RoundCreate():
    pass


class RoundUpdate():
    pass


class Round(RoundBase):
    id: int

    class Config:
        orm_mode = True
