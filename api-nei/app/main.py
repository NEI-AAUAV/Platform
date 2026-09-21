from contextlib import asynccontextmanager

from fastapi import FastAPI, HTTPException, status
from fastapi.staticfiles import StaticFiles
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import ORJSONResponse
from sqlalchemy import text

from app.api.api_v1 import router as api_v1_router
from app.db.init_db import init_db
from app.db.session import engine
from app.core.logging import init_logging
from app.core.config import settings
from app.core.extension_scopes import load_scopes_from_manifests
from app.core.dynamic_oauth import dynamic_oauth2_scheme
from app.integrations.authentik import authentik_client


@asynccontextmanager
async def lifespan(_: FastAPI):
    init_logging()
    init_db()
    # Register extension scopes from manifests
    load_scopes_from_manifests()
    # Update OAuth2 scheme with extension scopes
    dynamic_oauth2_scheme.update_scopes()
    authentik_client.start()
    try:
        yield
    finally:
        await authentik_client.close()


app = FastAPI(
    title="NEI API",
    lifespan=lifespan,
    default_response_class=ORJSONResponse,
    servers=[
        {"url": "/", "description": "Dev server"},
        {"url": "https://nei.web.ua.pt", "description": "Production environment"},
    ],
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.BACKEND_CORS_ORIGINS,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


app.mount(settings.STATIC_STR, StaticFiles(directory="static"), name="static")
app.include_router(api_v1_router, prefix=settings.API_V1_STR)


@app.get("/health/live", include_in_schema=False)
def health_live() -> dict[str, str]:
    return {"status": "ok"}


@app.get("/health/ready", include_in_schema=False)
def health_ready() -> dict[str, str]:
    try:
        with engine.connect() as connection:
            connection.execute(text("SELECT 1"))
    except Exception as exc:
        raise HTTPException(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            detail="Database unavailable",
        ) from exc
    return {"status": "ok"}

if __name__ == "__main__":
    # Use this for debugging purposes only
    import uvicorn

    uvicorn.run(app, host="0.0.0.0", port=8080, log_level="debug")
