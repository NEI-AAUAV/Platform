from app.crud.base import CRUDBase
from app.models.team import TeamSection
from app.schemas.team import TeamSectionCreate, TeamSectionUpdate


class CRUDTeamSection(CRUDBase[TeamSection, TeamSectionCreate, TeamSectionUpdate]):
    _foreign_key_checks = {
        "fk_team_section_mandate_team_mandate": "Team mandate not found!",
    }


team_section = CRUDTeamSection(TeamSection)
