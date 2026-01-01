from fastapi import APIRouter

from . import course, role, user, patch, userrole, tree


api_v1_router = APIRouter()

api_v1_router.include_router(course.router, prefix="/course", tags=["Course"])
api_v1_router.include_router(role.router, prefix="/role", tags=["Role"])
api_v1_router.include_router(user.router, prefix="/user", tags=["User"])
api_v1_router.include_router(userrole.router, prefix="/userrole", tags=["UserRole"])
api_v1_router.include_router(tree.router, prefix="/tree", tags=["Tree"])
api_v1_router.include_router(patch.router, prefix="/patch", tags=["Patch"])
