from fastapi import APIRouter
from .api_v1 import modality, competition, team, participant, course, group

api_v1_router = APIRouter()
api_v1_router.include_router(modality.router, prefix="/modality", tags=["Modalidade"])
api_v1_router.include_router(competition.router, prefix="/competition", tags=["Competição"])
api_v1_router.include_router(team.router, prefix="/team", tags=["Equipa"])
api_v1_router.include_router(participant.router, prefix="/participant", tags=["Participante"])
api_v1_router.include_router(course.router, prefix="/course", tags=["Curso"])
api_v1_router.include_router(group.router, prefix="/group", tags=["Grupo"])