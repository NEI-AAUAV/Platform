from app.crud.base import CRUDBase
from app.models.team import TeamCategory
from app.schemas.team import TeamCategoryCreate, TeamCategoryUpdate


class CRUDTeamCategory(CRUDBase[TeamCategory, TeamCategoryCreate, TeamCategoryUpdate]):
    _foreign_key_checks = {
        "fk_team_category_mandate_team_mandate": "Team mandate not found!",
    }


team_category = CRUDTeamCategory(TeamCategory)
