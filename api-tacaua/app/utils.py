import json
from enum import Enum
from typing import Any, Callable

from fastapi import FastAPI
from pydantic import model_validator
from fastapi.routing import APIRoute


class EnumList(Enum):
    """An Enum convertable to a list of values.

    This can be useful to return a list of possible values for a frontend form.
    """

    @classmethod
    def list(cls):
        return list(map(lambda c: c.value, cls))


class ValidateFromJson:
    """Validates schemas that are stringified.

    This is useful to validate requests with a form data containing an image
    file and a schema stringified.
    """

    @model_validator(mode="before")
    @classmethod
    def load_from_json(cls, data: Any) -> Any:
        if isinstance(data, dict):
            return data
        return json.loads(data)


def update_schema_name(app: FastAPI, function: Callable, name: str) -> None:
    """
    Update the Pydantic schema name for a FastAPI function that takes
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
