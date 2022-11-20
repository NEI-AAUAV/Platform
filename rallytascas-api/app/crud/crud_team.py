from sqlalchemy.orm import Session
from datetime import datetime

from app.exception import APIException
from app.crud.base import CRUDBase
from app.models.team import Team
from app.schemas.team import TeamInDB, TeamCreate, TeamUpdate, Checkpoint

class CRUDTeam(CRUDBase[Team, TeamCreate, TeamUpdate]):

    def add_checkpoint(self, db: Session, team: Team, checkpoint: Checkpoint) -> TeamInDB:
        time = datetime.now()
        index = checkpoint.checkpoint_id
        if len(team.scores) == index-1:
            team.scores.append(checkpoint.score)
            team.times.append(time)
        else:
            raise APIException(status_code=400, detail="Checkpoint not in order, or already passed")
        db.add(team)
        db.commit()
        return team

team = CRUDTeam(Team)