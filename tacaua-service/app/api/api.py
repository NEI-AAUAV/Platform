from fastapi import APIRouter
from .api_v1 import modality, competition, team

api_v1_router = APIRouter()
api_v1_router.include_router(modality.router, prefix="/modality", tags=["Modalidade"])
api_v1_router.include_router(competition.router, prefix="/competition", tags=["Competição"])
api_v1_router.include_router(team.router, prefix="/team", tags=["Equipa"])
