from fastapi import APIRouter

from app.api.api_v1.endpoints import tacaua_game
from app.api.api_v1.endpoints import notes
from app.api.api_v1.endpoints import faina


api_router = APIRouter()
api_router.include_router(faina.router, prefix="/faina", tags=["Faina"])
api_router.include_router(tacaua_game.router, prefix="/tacaua/games", tags=["Taça UA"])
api_router.include_router(notes.router, prefix="/notes", tags=["Notes"])
