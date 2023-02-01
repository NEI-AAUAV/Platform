from app.crud.base import CRUDBase
from app.models.team_colaborators import TeamColaborators
from app.schemas.team_colaborators import TeamColaboratorsCreate, TeamColaboratorsUpdate


class CRUDTeamColaborators(CRUDBase[TeamColaborators, TeamColaboratorsCreate, TeamColaboratorsUpdate]):
    ...


team_colaborators = CRUDTeamColaborators(TeamColaborators)
