from typing import Set, TypeVar, Callable, Type
from pydantic import BaseModel

_C = TypeVar("_C", bound=BaseModel)


def optional(*, exclude: Set[str] = set()) -> Callable[[Type[_C]], Type[_C]]:
    """Decorator function used to modify a pydantic model's fields to all be optional.

    Can also define fields to exclude from being optional.

    Based on https://github.com/samuelcolvin/pydantic/issues/1223#issuecomment-775363074
    """

    def dec(_cls: Type[_C]) -> Type[_C]:
        for field in _cls.__fields__:
            if field in exclude:
                continue

            _cls.__fields__[field].required = False
        return _cls

    return dec
