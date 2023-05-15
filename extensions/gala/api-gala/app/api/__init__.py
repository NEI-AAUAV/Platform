from fastapi import APIRouter

from . import table, user

router = APIRouter()
router.include_router(table.router, prefix="/table", tags=["Table"])
router.include_router(user.router, prefix="/users", tags=["User"])
