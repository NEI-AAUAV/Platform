from contextlib import asynccontextmanager

from fastapi import FastAPI
from fastapi.staticfiles import StaticFiles
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import ORJSONResponse

from loguru import logger

from app.api.api_v1 import router as api_v1_router
from app.db.init_db import init_db
from app.db.session import SessionLocal
from app.core.logging import init_logging
from app.core.config import settings
from app.core.extension_scopes import load_scopes_from_manifests
from app.core.dynamic_oauth import dynamic_oauth2_scheme


@asynccontextmanager
async def lifespan(_: FastAPI):
    init_logging()
    init_db()
    # Register extension scopes from manifests
    load_scopes_from_manifests()
    # Update OAuth2 scheme with extension scopes
    dynamic_oauth2_scheme.update_scopes()
    # Remove OAuth state rows left over from previous sessions
    try:
        from app.api.api_v1.auth.oidc import cleanup_expired_oauth_states
        db = SessionLocal()
        try:
            n = cleanup_expired_oauth_states(db)
            if n:
                logger.info(f"Cleaned up {n} expired OAuth state row(s) on startup")
        finally:
            db.close()
    except Exception:
        logger.warning("OAuth state cleanup on startup failed — continuing")
    yield


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

if __name__ == "__main__":
    # Use this for debugging purposes only
    import uvicorn

    uvicorn.run(app, host="0.0.0.0", port=8080, log_level="debug")
