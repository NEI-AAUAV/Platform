from app.crud.base import CRUDBase
from app.models.team import TeamRole
from app.schemas.team import TeamRoleCreate, TeamRoleUpdate


class CRUDTeamRole(CRUDBase[TeamRole, TeamRoleCreate, TeamRoleUpdate]):
    ...


team_role = CRUDTeamRole(TeamRole)
