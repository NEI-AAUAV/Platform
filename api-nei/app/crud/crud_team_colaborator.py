from typing import Optional, List

from sqlalchemy.orm import Session

from app.crud.base import CRUDBase
from app.models.team import TeamColaborator
from app.schemas.team import TeamColaboratorCreate, TeamColaboratorUpdate


class CRUDTeamColaborator(
    CRUDBase[TeamColaborator, TeamColaboratorCreate, TeamColaboratorUpdate]
):
    _foreign_key_checks = {"fk_team_colaborator_user_id_user": "User not found!"}
    _unique_violation_msg = "User is already a colaborator"

    def get_colaborators_by(
        self, *, db: Session, mandate: Optional[str] = None
    ) -> List[TeamColaborator]:
        """
        Return team_colaborator for a certain mandate
        """
        query = db.query(TeamColaborator)
        if mandate is not None:
            query = query.filter_by(mandate=mandate)
        return query.all()


team_colaborator = CRUDTeamColaborator(TeamColaborator)
