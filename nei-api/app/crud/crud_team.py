from sqlalchemy.orm import Session

from app.crud.base import CRUDBase
from app.models.team import Team
from app.schemas.team import TeamCreate, TeamUpdate

from typing import List


class CRUDTeam(CRUDBase[Team, TeamCreate, TeamUpdate]):

    def get_team_by_mandate(self, db: Session, mandate: int) -> List[Team]:
        """
        Return team for a certain mandate
        """
        return db.query(Team).filter(Team.mandate == mandate).all()


team = CRUDTeam(Team)
