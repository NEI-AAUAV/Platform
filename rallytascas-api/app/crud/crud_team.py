from typing import Dict, Any, Union
from datetime import datetime

from sqlalchemy.orm import Session

from app.exception import APIException
from app.crud.base import CRUDBase
from app.models.team import Team
from app.schemas.team import TeamCreate, TeamUpdate, Checkpoint


class CRUDTeam(CRUDBase[Team, TeamCreate, TeamUpdate]):

    def create(self, db: Session, *, obj_in: TeamCreate) -> Team:
        # TODO: update classification
        return super().create(db, obj_in=obj_in)

    def update(self, db: Session, *, id: int, obj_in: Union[TeamUpdate, Dict[str, Any]]) -> Team:
        # TODO: update classification
        return super().update(db, id=id, obj_in=obj_in)

    def add_checkpoint(self, db: Session, team: Team, checkpoint: Checkpoint) -> Team:
        # TODO: update classification
        time = datetime.now()
        index = checkpoint.checkpoint_id
        if len(team.scores) == index-1:
            team.scores.append(checkpoint.score)
            team.times.append(time)
        else:
            raise APIException(
                status_code=400, detail="Checkpoint not in order, or already passed")
        db.add(team)
        db.commit()
        return team


team = CRUDTeam(Team)
