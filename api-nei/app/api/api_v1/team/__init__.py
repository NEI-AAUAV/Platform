from fastapi import APIRouter

from . import team_mandate, team_member


router = APIRouter()
router.include_router(team_mandate.router, prefix="/mandate")
router.include_router(team_member.router, prefix="/member")
