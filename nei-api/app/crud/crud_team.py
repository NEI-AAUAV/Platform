from re import T
from sqlalchemy.orm import Session

from app.crud.base import CRUDBase
from app.models.team import Team
from app.schemas.team import TeamCreate, TeamUpdate, TeamInDB

from typing import List

from datetime import datetime


class CRUDTeam(CRUDBase[Team, TeamCreate, TeamUpdate]):
    def get_team_by_mandato(self, db: Session, mandato: int) ->TeamInDB:
        """
        Return team for a certain mandato
        """
        return db.query(Team).filter(Team.mandato == mandato)

team = CRUDTeam(Team)
