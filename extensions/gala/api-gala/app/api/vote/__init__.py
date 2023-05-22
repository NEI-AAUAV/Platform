from fastapi import APIRouter, Depends

from app.api.time_slots.util import check_votes_open

from . import get, create, edit, vote

router = APIRouter()
router.include_router(get.router)
router.include_router(create.router)
router.include_router(edit.router)
router.include_router(vote.router, dependencies=[Depends(check_votes_open)])
