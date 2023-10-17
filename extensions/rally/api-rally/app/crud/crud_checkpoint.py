from typing import Optional

from sqlalchemy.orm import Session

from app.crud.base import CRUDBase
from app.models.team import Team
from app.models.checkpoint import CheckPoint
from app.schemas.checkpoint import CheckPointCreate, CheckPointUpdate


class CRUDCheckPoint(CRUDBase[CheckPoint, CheckPointCreate, CheckPointUpdate]):
    def get_next(self, db: Session, team_id: int) -> Optional[CheckPoint]:
        team = db.query(Team).get(team_id)

        if team is not None:
            index = len(team.times) + 1
            checkpoint = self.get(db=db, id=index)
            return checkpoint

        return None


checkpoint = CRUDCheckPoint(CheckPoint)
