#!/usr/bin/env python3

from typing import AsyncGenerator
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import ORJSONResponse

from contextlib import asynccontextmanager

from app.api import router
from app.core.db import DatabaseClient, get_client, get_db
from app.core.db.init import init_db
from app.core.db.types import DBType
from app.core.logging import init_logging
from app.core.config import Settings, get_settings


@asynccontextmanager
async def lifespan(app: FastAPI) -> AsyncGenerator[None, None]:
    init_logging()
    settings: Settings = app.dependency_overrides.get(get_settings, get_settings)()
    client: DatabaseClient = await app.dependency_overrides.get(get_client, get_client)(
        settings
    )
    db: DBType = await app.dependency_overrides.get(get_db, get_db)(settings, client)
    await init_db(db)
    yield
    client.close()


settings = get_settings()

app = FastAPI(
    title="GALA API", lifespan=lifespan, default_response_class=ORJSONResponse
)
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.BACKEND_CORS_ORIGINS,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
app.include_router(router, prefix=settings.API_V1_STR)

if __name__ == "__main__":
    # Use this for debugging purposes only
    import uvicorn

    uvicorn.run(app, host="0.0.0.0", port=8004, log_level="debug")
