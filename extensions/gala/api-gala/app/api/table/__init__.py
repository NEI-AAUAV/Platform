from fastapi import APIRouter

from . import get, create, edit, reserve, confirm, transfer, remove

router = APIRouter()
router.include_router(get.router)
router.include_router(create.router)
router.include_router(edit.router)
router.include_router(reserve.router)
router.include_router(confirm.router)
router.include_router(transfer.router)
router.include_router(remove.router)
