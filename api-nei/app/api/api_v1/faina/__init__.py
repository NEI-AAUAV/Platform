from fastapi import APIRouter

from . import faina_role, faina_member, faina


router = APIRouter()
router.include_router(faina_role.router, prefix="/role")
router.include_router(faina_member.router, prefix="/member")
router.include_router(faina.router)
