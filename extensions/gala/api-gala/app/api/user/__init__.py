from fastapi import APIRouter

from . import get, create, edit

router = APIRouter()
router.include_router(get.router)
router.include_router(create.router)
router.include_router(edit.router)
