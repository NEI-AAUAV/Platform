from sqlalchemy.orm import Session
from datetime import datetime

from app.crud.base import CRUDBase
from app.models.team import Team
from app.schemas.teams import TeamInDB, TeamCreate, TeamUpdate, Checkpoint

class CRUDTeam(CRUDBase[Team, TeamCreate, TeamUpdate]):

    def add_checkpoint(self, db: Session, team: Team, checkpoint: Checkpoint) -> TeamInDB:
        time = datetime.now()
        index = checkpoint["checkpoint_id"]
        team.scores[index] = checkpoint["score"]
        team.times[index] = time
        db.add(team)
        db.commit()
        return team

team = CRUDTeam(Team)