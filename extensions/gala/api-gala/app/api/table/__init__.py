from fastapi import APIRouter, Depends

from app.api.time_slots.util import check_tables_open

from . import get, create, edit, reserve, confirm, transfer, remove, merge

router = APIRouter()
router.include_router(get.router)
router.include_router(create.router)
router.include_router(edit.router, dependencies=[Depends(check_tables_open)])
router.include_router(reserve.router, dependencies=[Depends(check_tables_open)])
router.include_router(confirm.router, dependencies=[Depends(check_tables_open)])
router.include_router(transfer.router, dependencies=[Depends(check_tables_open)])
router.include_router(remove.router, dependencies=[Depends(check_tables_open)])
router.include_router(merge.router)
