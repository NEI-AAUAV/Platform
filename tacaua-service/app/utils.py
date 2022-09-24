import json
from enum import Enum
from typing import Callable, Callable, Awaitable, Type
from pydantic import BaseModel
from fastapi import FastAPI, Response
from fastapi.routing import APIRoute
from starlette.middleware.base import BaseHTTPMiddleware
from starlette.requests import Request
from starlette.responses import StreamingResponse
from starlette.concurrency import iterate_in_threadpool

from app.core.logging import logger


class Ignore(BaseModel):
    # TODO: remove this maybe
    pass


class EnumList(Enum):

    @classmethod
    def list(cls):
        return list(map(lambda c: c.value, cls))


class LogStatsMiddleware(BaseHTTPMiddleware):
    async def dispatch(  # type: ignore
        self, request: Request, call_next: Callable[[Request], Awaitable[StreamingResponse]],
    ) -> Response:
        logger.debug(request.url)
        response = await call_next(request)
        response_body = [section async for section in response.body_iterator]
        response.body_iterator = iterate_in_threadpool(iter(response_body))
        logger.debug(response_body[0].decode())
        return response


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
