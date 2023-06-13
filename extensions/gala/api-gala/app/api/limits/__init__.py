from fastapi import APIRouter

from . import get, edit

router = APIRouter()
router.include_router(get.router)
router.include_router(edit.router)
