from fastapi import FastAPI
from fastapi.staticfiles import StaticFiles
from fastapi.middleware.cors import CORSMiddleware

from app.db.init_db import init_db
from app.api.api_v1.api import api_router
from app.core.logging import init_logging
from app.core.config import settings

app = FastAPI(title="NEI API")
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.BACKEND_CORS_ORIGINS,
    allow_credentials=False,
    allow_methods=["*"],
    allow_headers=["*"],
)
init_db()
app.mount("/static", StaticFiles(directory="static"), name="static")
app.add_event_handler("startup", init_logging)
app.include_router(api_router, prefix=settings.API_V1_STR)


if __name__ == "__main__":
    # Use this for debugging purposes only
    import uvicorn

    uvicorn.run(app, host="0.0.0.0", port=8001, log_level="debug")