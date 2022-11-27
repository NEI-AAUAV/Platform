from typing import Dict, Any, Union, List
from datetime import datetime

from sqlalchemy.orm import Session

from app.exception import APIException
from app.crud.base import CRUDBase
from app.models.team import Team
from app.schemas.team import TeamCreate, TeamUpdate


class CRUDTeam(CRUDBase[Team, TeamCreate, TeamUpdate]):

    def update_classification(self, db: Session) -> None:
        teams = self.get_multi(db=db)
        teams.sort(key=lambda t: (-sum(t.scores), -len(t.scores), t.name))
        for i, team in enumerate(teams):
            setattr(team, 'classification', i + 1)
            db.add(team)
        db.commit()

    def create(self, db: Session, *, obj_in: TeamCreate) -> Team:
        team = super().create(db, obj_in=obj_in)
        self.update_classification(db=db)
        db.refresh(team)
        return team

    def update(self, db: Session, *, id: int, obj_in: Union[TeamUpdate, Dict[str, Any]]) -> Team:
        team = super().update(db, id=id, obj_in=obj_in)
        self.update_classification(db=db)
        db.refresh(team)
        return team

    def add_checkpoint(self, db: Session, team: Team, checkpoint_id: int, score: int) -> Team:
        time = datetime.now()
        if len(team.scores) == checkpoint_id - 1:
            team.scores.append(score)
            team.times.append(time)
        else:
            raise APIException(
                status_code=400, detail="Checkpoint not in order, or already passed")
        db.add(team)
        db.commit()
        self.update_classification(db=db)
        db.refresh(team)
        return team

    def get_by_checkpoint(self, db: Session, checkpoint_id: int) -> List[Team]:
        teams = self.get_multi(db=db)
        return [t for t in teams if len(t.scores) == checkpoint_id - 1]


team = CRUDTeam(Team)
