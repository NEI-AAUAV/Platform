from fastapi import APIRouter

from app.api.api_v1.endpoints import tacaua_game
from app.api.api_v1.endpoints import notes
from app.api.api_v1.endpoints import faina
from app.api.api_v1.endpoints import faina_member
from app.api.api_v1.endpoints import faina_roles
from app.api.api_v1.endpoints import team_roles
from app.api.api_v1.endpoints import team
from app.api.api_v1.endpoints import team_colaborators


api_router = APIRouter()
api_router.include_router(team.router, prefix="/team", tags=["Team"])
api_router.include_router(team_colaborators.router, prefix="/team/colaborators", tags=["Team Colaborators"])
api_router.include_router(team_roles.router, prefix="/team/roles", tags=["Team Roles"])
api_router.include_router(faina_roles.router, prefix="/faina/roles", tags=["Faina Roles"])
api_router.include_router(faina_member.router, prefix="/faina/member", tags=["Faina Member"])
api_router.include_router(faina.router, prefix="/faina", tags=["Faina"])
api_router.include_router(tacaua_game.router, prefix="/tacaua/games", tags=["Taça UA"])
api_router.include_router(notes.router, prefix="/notes", tags=["Notes"])
