from typing import List

from sqlalchemy.orm import Session

from app.crud.base import CRUDBase
from app.models.team import TeamMember
from app.schemas.team import TeamMemberCreate, TeamMemberUpdate


class CRUDTeamMember(CRUDBase[TeamMember, TeamMemberCreate, TeamMemberUpdate]):
    _foreign_key_checks = {
        "fk_team_member_section_id_team_section": "Team section not found!",
        "fk_team_member_user_id_user": "User not found!",
        "fk_team_member_mandate_team_mandate": "Team mandate not found!",
    }

    def get_by_section(self, db: Session, section_id: int) -> List[TeamMember]:
        """Return team members for a given section."""
        return db.query(TeamMember).filter(TeamMember.section_id == section_id).all()


team_member = CRUDTeamMember(TeamMember)
