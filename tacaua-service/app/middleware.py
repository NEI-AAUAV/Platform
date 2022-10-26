from typing import Callable, Callable, Awaitable

from fastapi import Response
from starlette.middleware.base import BaseHTTPMiddleware
from starlette.requests import Request
from starlette.responses import StreamingResponse
from starlette.concurrency import iterate_in_threadpool

from app.core.logging import logger


class LogStatsMiddleware(BaseHTTPMiddleware):
    async def dispatch(  # type: ignore
        self, request: Request, call_next: Callable[[Request], Awaitable[StreamingResponse]],
    ) -> Response:
        log = str(request.url).startswith("http://localhost:8000/api")
        log and logger.debug(request.url)
        response = await call_next(request)
        response_body = [section async for section in response.body_iterator]
        response.body_iterator = iterate_in_threadpool(iter(response_body))
        log and logger.debug(response_body[0].decode())
        return response
