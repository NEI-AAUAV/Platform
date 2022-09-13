from fastapi import APIRouter
from .api_v1 import modality, competition

api_v1_router = APIRouter()
api_v1_router.include_router(modality.router, prefix="/modality", tags=["Modalidade"])
api_v1_router.include_router(competition.router, prefix="/competition", tags=["Competição"])
