from sqlalchemy.orm import Session

from app.crud.base import CRUDBase
from app.models.team_member import TeamMember
from app.schemas.team_member import TeamMemberCreate, TeamMemberUpdate

from typing import List


class CRUDTeamMember(CRUDBase[TeamMember, TeamMemberCreate, TeamMemberUpdate]):

    def get_team_by_mandate(self, db: Session, mandate: int) -> List[TeamMember]:
        """
        Return team_member for a certain mandate
        """
        return db.query(TeamMember).filter(TeamMember.mandate == mandate).all()


team_member = CRUDTeamMember(TeamMember)
