from fastapi import APIRouter

from . import (
    note, video, news, partner, merch, history, rgm, redirect, user,
    faina, senior, team,
    tacaua_ws, auth)


router = APIRouter()
router.include_router(faina.router, prefix="/faina", tags=["Faina"])
router.include_router(senior.router, prefix="/senior", tags=["Senior"])
router.include_router(team.router, prefix="/team", tags=["Team"])
router.include_router(video.router, prefix="/video", tags=["Video"])
router.include_router(redirect.router, prefix="/redirect", tags=["Redirect"])
router.include_router(news.router, prefix="/news", tags=["News"])
router.include_router(note.router, prefix="/note", tags=["Note"])
router.include_router(history.router, prefix="/history", tags=["History"])
router.include_router(rgm.router, prefix="/rgm", tags=["RGM"])
router.include_router(merch.router, prefix="/merch", tags=["Merchandising"])
router.include_router(partner.router, prefix="/partner", tags=["Partner"])
router.include_router(user.router, prefix="/user", tags=["User"])
router.include_router(tacaua_ws.router, prefix="/ws", tags=["WebSocket"])
router.include_router(auth.router, prefix="/auth", tags=["Authentication"])
