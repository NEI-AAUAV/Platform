from fastapi import APIRouter

from app.api.logger_router import ContextIncludedRoute

from .v1 import (
    modality,
    competition,
    team,
    participant,
    course,
    group,
    match,
    standings,
)


api_v1_router = APIRouter(route_class=ContextIncludedRoute)
api_v1_router.include_router(modality.router, prefix="/modalities", tags=["Modalidade"])
api_v1_router.include_router(
    competition.router, prefix="/competitions", tags=["Competição"]
)
api_v1_router.include_router(team.router, prefix="/teams", tags=["Equipa"])
api_v1_router.include_router(
    participant.router, prefix="/participants", tags=["Participante"]
)
api_v1_router.include_router(course.router, prefix="/courses", tags=["Curso"])
api_v1_router.include_router(group.router, prefix="/groups", tags=["Grupo"])
api_v1_router.include_router(match.router, prefix="/matches", tags=["Match"])
api_v1_router.include_router(standings.router, prefix="/standings", tags=["Standings"])
