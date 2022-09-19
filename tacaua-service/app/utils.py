from pydantic import BaseModel
from enum import Enum

import inspect
from typing import Callable, Type

from fastapi import Form, FastAPI
from fastapi.routing import APIRoute
from pydantic.fields import ModelField


class Ignore(BaseModel):
    pass


class EnumList(Enum):

    @classmethod
    def list(cls):
        return list(map(lambda c: c.value, cls))


def schema_as_form(cls: Type[BaseModel]):
    new_parameters = []

    for field_name, model_field in cls.__fields__.items():
        model_field: ModelField  # type: ignore

        new_parameters.append(
            inspect.Parameter(
                model_field.alias,
                inspect.Parameter.POSITIONAL_ONLY,
                default=Form(...) if model_field.required else Form(
                    model_field.default),
                annotation=model_field.outer_type_,
            )
        )

    async def as_form(**data):
        return cls(**data)

    sig = inspect.signature(as_form)
    sig = sig.replace(parameters=new_parameters)
    as_form.__signature__ = sig  # type: ignore
    setattr(cls, 'as_form', as_form)
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
