from fastapi import APIRouter

from app.api.api_v1.endpoints import tacaua_game


api_router = APIRouter()
api_router.include_router(tacaua_game.router, prefix="/tacaua/games", tags=["games"])
