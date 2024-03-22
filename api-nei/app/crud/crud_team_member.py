from typing import List

from sqlalchemy import select
from sqlalchemy.orm import Session

from app.crud.base import CRUDBase
from app.models.team import TeamMember
from app.schemas.team import TeamMemberCreate, TeamMemberUpdate


class CRUDTeamMember(CRUDBase[TeamMember, TeamMemberCreate, TeamMemberUpdate]):
    _foreign_key_checks = {
        "fk_team_member_role_id_team_role": "Team role not found!",
        "fk_team_member_user_id_user": "User not found!",
    }

    def get_team_mandates(self, db: Session) -> List[str]:
        """
        Return every distinct mandate
        """
        stmt = select(TeamMember.mandate).distinct()
        return db.scalars(stmt).all()

    def get_team_by_mandate(self, db: Session, mandate: str) -> List[TeamMember]:
        """
        Return team_member for a certain mandate
        """
        return db.query(TeamMember).filter(TeamMember.mandate == mandate).all()


team_member = CRUDTeamMember(TeamMember)
