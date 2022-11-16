from sqlalchemy.orm import Session
from datetime import datetime

from app.crud.base import CRUDBase
from app.models.team import Team
from app.schemas.teams import TeamInDB, TeamCreate, TeamUpdate, Checkpoint

class CRUDTeam(CRUDBase[Team, TeamCreate, TeamUpdate]):
    def get(self, db: Session, id: int) -> Team:
        return db.query(self.model).filter(self.model.id == id).first()

    def get_all(self, db: Session) -> list[Team]:
        return super().get_multi(db)

    def add_checkpoint(self, db: Session, team: Team, checkpoint: Checkpoint) -> TeamInDB:
        time = datetime.now()
        index = Checkpoint["checkpoint_id"]
        team.scores[index] = Checkpoint["score"]
        team.times[index] = time
        db.add(team)
        db.commit()
        return team
