from app.crud.base import CRUDBase
from app.models.team_colaborator import TeamColaborator
from app.schemas.team_colaborator import TeamColaboratorCreate, TeamColaboratorUpdate


class CRUDTeamColaborator(CRUDBase[TeamColaborator, TeamColaboratorCreate, TeamColaboratorUpdate]):
    ...


team_colaborator = CRUDTeamColaborator(TeamColaborator)
