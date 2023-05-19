from fastapi import APIRouter

from . import get, create, edit, vote

router = APIRouter()
router.include_router(get.router)
router.include_router(create.router)
router.include_router(edit.router)
router.include_router(vote.router)
