import json
from enum import Enum
from typing import Callable, Type

from pydantic import BaseModel
from fastapi import FastAPI
from fastapi.routing import APIRoute


class Ignore(BaseModel):
    # TODO: remove this maybe
    pass


class EnumList(Enum):

    @classmethod
    def list(cls):
        return list(map(lambda c: c.value, cls))


def validate_to_json(cls: Type[BaseModel]):
    def __get_validators__(cls):
        yield cls.validate_to_json

    def validate_to_json(cls, value):
        if isinstance(value, str):
            return cls(**json.loads(value))
        return value

    setattr(cls, '__get_validators__', classmethod(__get_validators__))
    setattr(cls, 'validate_to_json', classmethod(validate_to_json))
    return cls


def update_schema_name(app: FastAPI, function: Callable, name: str) -> None:
    """
    Updates the Pydantic schema name for a FastAPI function that takes
    in a fastapi.UploadFile = File(...) or bytes = File(...).

    This is a known issue that was reported on FastAPI#1442 in which
    the schema for file upload routes were auto-generated with no
    customization options. This renames the auto-generated schema to
    something more useful and clear.

    Args:
        app: The FastAPI application to modify.
        function: The function object to modify.
        name: The new name of the schema.
    """
    for route in app.routes:
        if type(route) is APIRoute and route.endpoint is function:
            route.body_field.type_.__name__ = name
            break
