from sqlalchemy.orm import Session

from app.crud.base import CRUDBase
from app.models.team import Team
from app.models.checkpoint import CheckPoint
from app.schemas.checkpoint import CheckPointCreate


class CRUDCheckPoint(CRUDBase[CheckPoint, CheckPointCreate, None]):
    
    def get_next(self, db: Session, team_id: int) -> CheckPoint:
        team = db.query(Team).get(team_id)
        index = len(team.scores) + 1
        checkpoint = self.get(db, index)
        return checkpoint


checkpoint = CRUDCheckPoint(CheckPoint)
