from enum import Enum
from typing import Type

from pydantic import BaseModel


class EnumList(Enum):

    @classmethod
    def list(cls):
        return list(map(lambda c: c.value, cls))


def include(fields: list[str]):
    """
    This decorator allows you to include default fields in the dictionary,
    and bypass the exclude_unset and exclude_none parameters.

    Usefult for fields like `created_at` and `updated_at`.
    """
    def decorator(cls: Type[BaseModel]):
        def to_dict(self, *args, **kwargs):
            # Get a dictionary representation of the model object
            d = super(cls, self).dict(*args, **kwargs)

            # Include fields in the dictionary
            # regardless of exclude_unset and exclude_none parameters
            for field in fields:
                if field not in d:
                    d[field] = getattr(self, field)

            return d

        cls.dict = to_dict
        return cls

    return decorator
