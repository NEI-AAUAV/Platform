from fastapi import APIRouter

from .api_v1 import course, role, user, patch


api_v1_router = APIRouter()

api_v1_router.include_router(course.router, prefix="/course", tags=["Course"])
api_v1_router.include_router(role.router, prefix="/role", tags=["Role"])
api_v1_router.include_router(user.router, prefix="/user", tags=["User"])
api_v1_router.include_router(patch.router, prefix="/patch", tags=["Patch"])
