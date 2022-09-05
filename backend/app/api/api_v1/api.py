from fastapi import APIRouter

from app.api.api_v1.endpoints import tacaua_game
from app.api.api_v1.endpoints import notes
from app.api.api_v1.endpoints import users

api_router = APIRouter()
api_router.include_router(tacaua_game.router, prefix="/tacaua/games", tags=["Taça UA"])
api_router.include_router(notes.router, prefix="/notes", tags=["Notes"])
api_router.include_router(users.router, prefix="/users", tags=["Users"])
