from fastapi import APIRouter

from app.api.api_v1.endpoints import merchandisings, tacaua_game
from app.api.api_v1.endpoints import notes, history, rgm, merchandisings, partners
from app.api.api_v1.endpoints import video, redirect, news, users, treeei


api_router = APIRouter()
api_router.include_router(tacaua_game.router, prefix="/tacaua/games", tags=["Taça UA Games"])
api_router.include_router(video.router, prefix="/videos", tags=["videos"])
api_router.include_router(redirect.router, prefix="/redirects", tags=["redirects"])
api_router.include_router(news.router, prefix="/news", tags=["news"])
api_router.include_router(notes.router, prefix="/notes", tags=["Notes"])
api_router.include_router(history.router, prefix="/history", tags=["History"])
api_router.include_router(rgm.router, prefix="/rgm", tags=["Rgm"])
api_router.include_router(merchandisings.router, prefix="/merch", tags=["Merchandisings"])
api_router.include_router(partners.router, prefix="/partners", tags=["Partners"])
api_router.include_router(users.router, prefix="/users", tags=["Users"])
api_router.include_router(treeei.router, prefix="/treeei", tags=["Tree EI"])
