from fastapi import APIRouter

from .api_v1 import notes, videos
from .api_v1 import faina
from .api_v1 import faina_member
from .api_v1 import faina_roles
from .api_v1 import team_roles
from .api_v1 import team
from .api_v1 import team_colaborators
from .api_v1 import seniors
from .api_v1 import seniors_students
from .api_v1 import videos, redirect, news, notes, users, treeei
from .api_v1 import history, rgm, merchandisings, partners


api_v1_router = APIRouter()
api_v1_router.include_router(seniors_students.router, prefix="/seniors/students", tags=["Seniors Students"])
api_v1_router.include_router(seniors.router, prefix="/seniors", tags=["Seniors"])
api_v1_router.include_router(team.router, prefix="/team", tags=["Team"])
api_v1_router.include_router(team_colaborators.router, prefix="/team/colaborators", tags=["Team Colaborators"])
api_v1_router.include_router(team_roles.router, prefix="/team/roles", tags=["Team Roles"])
api_v1_router.include_router(faina_roles.router, prefix="/faina/roles", tags=["Faina Roles"])
api_v1_router.include_router(faina_member.router, prefix="/faina/member", tags=["Faina Member"])
api_v1_router.include_router(faina.router, prefix="/faina", tags=["Faina"])
api_v1_router.include_router(videos.router, prefix="/videos", tags=["Videos"])
api_v1_router.include_router(redirect.router, prefix="/redirects", tags=["Redirect"])
api_v1_router.include_router(news.router, prefix="/news", tags=["News"])
api_v1_router.include_router(notes.router, prefix="/notes", tags=["Notes"])
api_v1_router.include_router(history.router, prefix="/history", tags=["History"])
api_v1_router.include_router(rgm.router, prefix="/rgm", tags=["Rgm"])
api_v1_router.include_router(merchandisings.router, prefix="/merch", tags=["Merchandisings"])
api_v1_router.include_router(partners.router, prefix="/partners", tags=["Partners"])
api_v1_router.include_router(users.router, prefix="/users", tags=["Users"])
api_v1_router.include_router(treeei.router, prefix="/treeei", tags=["Tree EI"])
