from fastapi import APIRouter

from app.api.api_v1.endpoints import notes, videos
from app.api.api_v1.endpoints import faina
from app.api.api_v1.endpoints import faina_member
from app.api.api_v1.endpoints import faina_roles
from app.api.api_v1.endpoints import team_roles
from app.api.api_v1.endpoints import team
from app.api.api_v1.endpoints import team_colaborators
from app.api.api_v1.endpoints import seniors
from app.api.api_v1.endpoints import seniors_students
from app.api.api_v1.endpoints import tacaua_game, redirect, news, notes, users, treeei
from app.api.api_v1.endpoints import history, rgm, merchandisings, partners
from app.api.api_v1.endpoints import redirect, news, users, treeei


api_router = APIRouter()
api_router.include_router(seniors_students.router, prefix="/seniors/students", tags=["Seniors Students"])
api_router.include_router(seniors.router, prefix="/seniors", tags=["Seniors"])
api_router.include_router(team.router, prefix="/team", tags=["Team"])
api_router.include_router(team_colaborators.router, prefix="/team/colaborators", tags=["Team Colaborators"])
api_router.include_router(team_roles.router, prefix="/team/roles", tags=["Team Roles"])
api_router.include_router(faina_roles.router, prefix="/faina/roles", tags=["Faina Roles"])
api_router.include_router(faina_member.router, prefix="/faina/member", tags=["Faina Member"])
api_router.include_router(faina.router, prefix="/faina", tags=["Faina"])
api_router.include_router(tacaua_game.router, prefix="/tacaua/games", tags=["Taça UA Games"])
api_router.include_router(videos.router, prefix="/videos", tags=["Videos"])
api_router.include_router(redirect.router, prefix="/redirects", tags=["Redirect"])
api_router.include_router(news.router, prefix="/news", tags=["News"])
api_router.include_router(notes.router, prefix="/notes", tags=["Notes"])
api_router.include_router(history.router, prefix="/history", tags=["History"])
api_router.include_router(rgm.router, prefix="/rgm", tags=["Rgm"])
api_router.include_router(merchandisings.router, prefix="/merch", tags=["Merchandisings"])
api_router.include_router(partners.router, prefix="/partners", tags=["Partners"])
api_router.include_router(users.router, prefix="/users", tags=["Users"])
api_router.include_router(treeei.router, prefix="/treeei", tags=["Tree EI"])
