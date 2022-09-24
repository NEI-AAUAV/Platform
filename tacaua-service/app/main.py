from fastapi import FastAPI, Request
from fastapi.staticfiles import StaticFiles
from fastapi.middleware.cors import CORSMiddleware

from app.db.init_db import init_db
from app.utils import update_schema_name, LogStatsMiddleware
from app.api.api import api_v1_router
from app.api.api_v1.modality import create_modality, update_modality
from app.api.api_v1.team import create_team, update_team
from app.core.logging import init_logging
from app.core.config import settings

app = FastAPI(title="Taça UA API")
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    # allow_origins=settings.BACKEND_CORS_ORIGINS,
    allow_credentials=False,
    allow_methods=["*"],
    allow_headers=["*"],
)
app.add_middleware(LogStatsMiddleware)
app.mount("/static", StaticFiles(directory="static"), name="static")
app.add_event_handler("startup", init_logging)
app.add_event_handler("startup", init_db)
app.include_router(api_v1_router, prefix=settings.API_V1_STR)

update_schema_name(app, create_modality, "ModalityCreateForm")
update_schema_name(app, update_modality, "ModalityUpdateForm")
update_schema_name(app, create_team, "TeamCreateForm")
update_schema_name(app, update_team, "TeamUpdateForm")


if __name__ == "__main__":
    # Use this for debugging purposes only
    import uvicorn

    uvicorn.run(app, host="0.0.0.0", port=8001, log_level="debug")
