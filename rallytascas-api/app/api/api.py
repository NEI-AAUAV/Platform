from fastapi import APIRouter
# from .api_v1 import
from .api_v1 import team

api_v1_router = APIRouter()

api_v1_router.include_router(team.router, prefix="/team", tags=["Team"])
