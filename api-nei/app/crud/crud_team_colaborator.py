from sqlalchemy.orm import Session

from app.crud.base import CRUDBase
from app.models.team_colaborator import TeamColaborator
from app.schemas.team_colaborator import TeamColaboratorCreate, TeamColaboratorUpdate

from typing import List


class CRUDTeamColaborator(CRUDBase[TeamColaborator, TeamColaboratorCreate, TeamColaboratorUpdate]):

    def get_colaborators_by(self, *, db: Session, mandate: str = None) -> List[TeamColaborator]:
        """
        Return team_colaborator for a certain mandate
        """
        query = db.query(TeamColaborator)
        if mandate:
            query = query.filter_by(mandate=mandate)
        return query.all()


team_colaborator = CRUDTeamColaborator(TeamColaborator)
