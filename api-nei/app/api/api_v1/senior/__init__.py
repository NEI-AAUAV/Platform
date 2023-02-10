from fastapi import APIRouter

from . import senior, senior_student


router = APIRouter()
router.include_router(senior_student.router, prefix="/student")
router.include_router(senior.router)
