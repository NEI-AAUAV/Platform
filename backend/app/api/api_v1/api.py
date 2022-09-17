from fastapi import APIRouter

from app.api.api_v1.endpoints import merchandisings, tacaua_game
from app.api.api_v1.endpoints import notes, history, rgm, merchandisings, partners


api_router = APIRouter()
api_router.include_router(tacaua_game.router, prefix="/tacaua/games", tags=["Taça UA"])
api_router.include_router(notes.router, prefix="/notes", tags=["Notes"])
api_router.include_router(history.router, prefix="/history", tags=["History"])
api_router.include_router(rgm.router, prefix="/rgm", tags=["Rgm"])
api_router.include_router(merchandisings.router, prefix="/merch", tags=["Merchandisings"])
api_router.include_router(partners.router, prefix="/partners", tags=["Partners"])
