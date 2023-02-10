from fastapi import FastAPI
from fastapi.staticfiles import StaticFiles
from fastapi.middleware.cors import CORSMiddleware

from app.api.api_v1 import router as api_v1_router
from app.db.init_db import init_db
from app.core.logging import init_logging
from app.core.config import settings

app = FastAPI(title="NEI API")
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.BACKEND_CORS_ORIGINS,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.mount(settings.STATIC_STR, StaticFiles(directory="static"), name="static")
app.add_event_handler("startup", init_logging)
app.add_event_handler("startup", init_db)
app.include_router(api_v1_router, prefix=settings.API_V1_STR)


if __name__ == "__main__":
    # Use this for debugging purposes only
    import uvicorn

    uvicorn.run(app, host="0.0.0.0", port=8080, log_level="debug")
