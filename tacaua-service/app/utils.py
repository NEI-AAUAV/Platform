from pydantic import BaseModel
from enum import Enum


class Ignore(BaseModel):
    pass


class EnumList(Enum):

    @classmethod
    def list(cls):
        return list(map(lambda c: c.value, cls))
