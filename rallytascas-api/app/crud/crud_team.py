import math
import random
from typing import Dict, Any, Union, List
from datetime import datetime

from sqlalchemy.orm import Session

from app.exception import APIException, CardNotActiveException, CardEffectException
from app.crud.base import CRUDBase
from app.models.team import Team
from app.schemas.team import TeamCreate, TeamUpdate, StaffScoresTeamUpdate, StaffCardsTeamUpdate


class CRUDTeam(CRUDBase[Team, TeamCreate, TeamUpdate]):

    def update_classification(self, db: Session) -> None:
        teams = self.get_multi(db=db)

        all_time_scores = [t.time_scores + [0] *
                           (8-len(t.time_scores)) for t in teams]

        min_time_scores = [min(map(lambda s: s or math.inf, l))
                           for l in zip(*all_time_scores)]

        def calc_time_score(_):
            i, s = _
            return min_time_scores[i] / s * 10 if s else 0

        def calc_question_scores(_):
            c1, s = _
            return 6 if c1 else s * 8

        def calc_pukes(_):
            c3, s = _
            return (s - 1 if c3 else s) * -20

        def calc_skips(_):
            c2, s = _
            return (s - 1 if c2 else s) * -8

        uniform_scores = {t.id: [
            list(map(calc_time_score, enumerate(t.time_scores))),
            list(map(calc_question_scores, [
                 (t.card1 == i + 1, s) for i, s in enumerate(t.question_scores)])),
            list(map(calc_pukes, [(t.card3 == i + 1, s)
                 for i, s in enumerate(t.pukes)])),
            list(map(calc_skips, [(t.card2 == i + 1, s)
                 for i, s in enumerate(t.skips)]))
        ] for t in teams}

        def calc_total(scores):
            return sum(sum(l) for l in scores)

        teams.sort(key=lambda t: (-calc_total(uniform_scores[t.id]), t.name))

        for i, team in enumerate(teams):
            setattr(team, 'total', int(calc_total(uniform_scores[team.id])))
            setattr(team, 'classification', i + 1)
            db.add(team)
        db.commit()

    def create(self, db: Session, *, obj_in: TeamCreate) -> Team:
        team = super().create(db, obj_in=obj_in)
        self.update_classification(db=db)
        db.refresh(team)
        return team

    def update(self, db: Session, *, id: int, obj_in: Union[TeamUpdate, Dict[str, Any]]) -> Team:
        team = self.get(db=db, id=id)
        if isinstance(obj_in, dict):
            update_data = obj_in
        else:
            update_data = obj_in.dict(exclude_unset=True)

        if (len({len(update_data.get(key) or getattr(team, key)) for key in
                 ('times', 'question_scores', 'time_scores', 'pukes', 'skips')}) != 1):
            raise APIException(
                status_code=400, detail="Lists must have the same size")

        team = super().update(db, id=id, obj_in=obj_in)
        self.update_classification(db=db)
        db.refresh(team)
        return team

    def add_checkpoint(self, db: Session, team: Team, checkpoint_id: int, obj_in: StaffScoresTeamUpdate) -> Team:
        time = datetime.now()
        # can only update when no scores have been done
        if len(team.times) != checkpoint_id - 1:
            raise APIException(
                status_code=400, detail="Checkpoint not in order, or already passed")

        team.question_scores.append(obj_in.question_score)
        team.time_scores.append(obj_in.time_score)
        team.pukes.append(obj_in.pukes)
        team.skips.append(obj_in.skips)
        team.times.append(time)

        # add cards randomly
        pity = len(team.times) == 7
        chance = random.random() > 0.7
        if chance or pity:
            for card in ('card1', 'card2', 'card3'):
                if getattr(team, card) == -1:
                    setattr(team, card, 0)
                    if chance:
                        break

        db.add(team)
        db.commit()
        self.update_classification(db=db)
        db.refresh(team)
        return team

    def activate_cards(self, db: Session, team: Team, checkpoint_id: int, obj_in: StaffCardsTeamUpdate) -> Team:
        # can only activate after scores have been done
        if len(team.times) != checkpoint_id:
            raise APIException(
                status_code=400, detail="Checkpoint not in order, or already passed")

        # question pass
        if obj_in.card1:
            if team.card1 != 0:
                raise CardNotActiveException()
            if team.question_scores[checkpoint_id]:
                raise CardEffectException()
            team.card1 = checkpoint_id
        # skip pass
        if obj_in.card2:
            if team.card2 != 0:
                raise CardNotActiveException()
            if team.skips[checkpoint_id] <= 0:
                raise CardEffectException()
            team.card2 = checkpoint_id
        # puke pass
        if obj_in.card3:
            if obj_in.card3 != 0:
                raise CardNotActiveException()
            if team.pukes[checkpoint_id] <= 0:
                raise CardEffectException()
            team.card3 = checkpoint_id

        db.add(team)
        db.commit()
        self.update_classification(db=db)
        db.refresh(team)
        return team

    def get_by_checkpoint(self, db: Session, checkpoint_id: int) -> List[Team]:
        teams = self.get_multi(db=db)
        return [t for t in teams if len(t.times) == checkpoint_id]


team = CRUDTeam(Team)
