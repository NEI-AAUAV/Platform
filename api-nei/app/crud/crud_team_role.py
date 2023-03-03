from app.crud.base import CRUDBase
from app.models.team_role import TeamRole
from app.schemas.team_role import TeamRoleCreate, TeamRoleUpdate


class CRUDTeamRole(CRUDBase[TeamRole, TeamRoleCreate, TeamRoleUpdate]):
    ...


team_role = CRUDTeamRole(TeamRole)
