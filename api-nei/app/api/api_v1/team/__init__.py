from fastapi import APIRouter

from . import team_member, team_colaborator, team_role


router = APIRouter()
router.include_router(team_member.router, prefix="/member")
router.include_router(team_colaborator.router, prefix="/colaborator")
router.include_router(team_role.router, prefix="/role")
