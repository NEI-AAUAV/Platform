from sqlalchemy.orm import Session

from app.crud.base import CRUDBase
from app.models.team_colaborator import TeamColaborator
from app.schemas.team_colaborator import TeamColaboratorCreate, TeamColaboratorUpdate

from typing import List


class CRUDTeamColaborator(CRUDBase[TeamColaborator, TeamColaboratorCreate, TeamColaboratorUpdate]):
    def get_colaborators_by_mandate(self, db: Session, mandate: int) -> List[TeamColaborator]:
        """
        Return team_colaborator for a certain mandate
        """
        return db.query(TeamColaborator).filter(TeamColaborator.mandate == mandate).all()


team_colaborator = CRUDTeamColaborator(TeamColaborator)
