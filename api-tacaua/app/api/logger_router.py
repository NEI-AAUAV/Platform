from uuid import uuid4
from typing import Callable

from loguru import logger
from fastapi import Request, Response
from fastapi.routing import APIRoute


class ContextIncludedRoute(APIRoute):
    def get_route_handler(self) -> Callable:
        original_route_handler = super().get_route_handler()

        async def custom_route_handler(request: Request) -> Response:
            url = str(request.url)
            request_id = str(uuid4())

            with logger.contextualize(request_id=request_id):
                logger.debug("{}", url, request_id)
                response: Response = await original_route_handler(request)

            response.headers["X-Request-ID"] = request_id
            return response

        return custom_route_handler
