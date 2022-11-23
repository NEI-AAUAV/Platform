from app.crud.base import CRUDBase
from app.models.team_roles import TeamRoles
from app.schemas.team_roles import TeamRolesCreate, TeamRolesUpdate


class CRUDTeamRoles(CRUDBase[TeamRoles, TeamRolesCreate, TeamRolesUpdate]):
    ...


team_roles = CRUDTeamRoles(TeamRoles)
