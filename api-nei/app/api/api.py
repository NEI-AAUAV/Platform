from fastapi import APIRouter

from .api_v1 import (
    note, video, news, partner, merch, history, rgm, redirect, user,
    faina, faina_member, faina_role,
    team, team_colaborator, team_role,
    senior, senior_student,
    treeei, tacaua_ws)


api_v1_router = APIRouter()
api_v1_router.include_router(senior_student.router, prefix="/senior/student", tags=["Senior Student"])
api_v1_router.include_router(senior.router, prefix="/senior", tags=["Seniors"])
api_v1_router.include_router(team.router, prefix="/team", tags=["NEI Member"])
api_v1_router.include_router(team_colaborator.router, prefix="/team/colaborator", tags=["NEI Colaborator"])
api_v1_router.include_router(team_role.router, prefix="/team/role", tags=["NEI Role"])
api_v1_router.include_router(faina_role.router, prefix="/faina/role", tags=["CF Role"])
api_v1_router.include_router(faina_member.router, prefix="/faina/member", tags=["CF Member"])
api_v1_router.include_router(faina.router, prefix="/faina", tags=["CF List"])
api_v1_router.include_router(video.router, prefix="/video", tags=["Video"])
api_v1_router.include_router(redirect.router, prefix="/redirect", tags=["Redirect"])
api_v1_router.include_router(news.router, prefix="/news", tags=["News"])
api_v1_router.include_router(note.router, prefix="/note", tags=["Note"])
api_v1_router.include_router(history.router, prefix="/history", tags=["History"])
api_v1_router.include_router(rgm.router, prefix="/rgm", tags=["RGM"])
api_v1_router.include_router(merch.router, prefix="/merch", tags=["Merchandising"])
api_v1_router.include_router(partner.router, prefix="/partner", tags=["Partner"])
api_v1_router.include_router(user.router, prefix="/user", tags=["User"])
api_v1_router.include_router(treeei.router, prefix="/treeei", tags=["Tree EI"])
api_v1_router.include_router(tacaua_ws.router, prefix="/ws", tags=["WebSocket"])
