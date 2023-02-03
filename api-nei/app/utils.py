from enum import Enum

class EnumList(Enum):

    @classmethod
    def list(cls):
        return list(map(lambda c: c.value, cls))
