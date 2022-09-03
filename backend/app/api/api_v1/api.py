from fastapi import APIRouter

from app.api.api_v1.endpoints import tacaua_game, video, redirect, news


api_router = APIRouter()
api_router.include_router(tacaua_game.router, prefix="/tacaua/games", tags=["games"])
api_router.include_router(video.router, prefix="/videos", tags=["videos"])
api_router.include_router(redirect.router, prefix="/redirects", tags=["redirects"])
api_router.include_router(news.router, prefix="/news", tags=["news"])