import math
import random
from typing import List
from datetime import datetime

from sqlalchemy.orm import Session

from app.exception import APIException, CardNotActiveException, CardEffectException
from app.crud.base import CRUDBase
from app.models.team import Team
from app.schemas.team import (
    TeamCreate,
    TeamUpdate,
    StaffScoresTeamUpdate,
    StaffCardsTeamUpdate,
)

locked_arrays = [
    "times",
    "question_scores",
    "time_scores",
    "pukes",
    "skips",
]


class CRUDTeam(CRUDBase[Team, TeamCreate, TeamUpdate]):
    def update_classification_unlocked(self, db: Session) -> None:
        teams = list(self.get_multi(db=db, for_update=True))

        all_time_scores = [
            t.time_scores + [0] * (8 - len(t.time_scores)) for t in teams
        ]

        min_time_scores = [
            min(map(lambda s: s if s != 0 else math.inf, scores))
            for scores in zip(*all_time_scores)
        ]

        def calc_time_score(checkpoint: int, score: int) -> int:
            return int(min_time_scores[checkpoint] / score * 10) if score != 0 else 0

        def calc_question_scores(used_card: bool, is_correct: bool) -> int:
            return 6 if used_card else int(is_correct) * 8

        def calc_pukes(used_card: bool, pukes: int) -> int:
            return (pukes - 1 if used_card else pukes) * -20

        def calc_skips(used_card: bool, skips: int) -> int:
            if skips > 0:
                return (skips - 1 if used_card else skips) * -8
            return abs(skips) * 4

        for t in teams:
            total_score = sum(
                calc_time_score(i, s) for i, s in enumerate(t.time_scores)
            )
            total_score += sum(
                calc_question_scores(t.card1 == i + 1, c)
                for i, c in enumerate(t.question_scores)
            )
            total_score += sum(
                calc_skips(t.card2 == i + 1, s) for i, s in enumerate(t.skips)
            )
            total_score += sum(
                calc_pukes(t.card3 == i + 1, p) for i, p in enumerate(t.pukes)
            )

            t.total = total_score

        teams.sort(key=lambda t: (-t.total, t.name))

        for i, team in enumerate(teams):
            team.classification = i + 1
            db.add(team)

    def update_classification(self, db: Session) -> None:
        with db.begin_nested():
            self.update_classification_unlocked(db)

    def create(self, db: Session, *, obj_in: TeamCreate) -> Team:
        team = super().create(db, obj_in=obj_in)
        self.update_classification(db=db)
        db.refresh(team)
        return team

    def update(self, db: Session, *, id: int, obj_in: TeamUpdate) -> Team:
        with db.begin_nested():
            team = self.get(db=db, id=id, for_update=True)
            update_data = obj_in.model_dump(exclude_unset=True)

            last_size = None
            for key in locked_arrays:
                size = len(update_data.get(key) or getattr(team, key))
                if last_size is not None and last_size != size:
                    raise APIException(
                        status_code=400, detail="Lists must have the same size"
                    )

                last_size = size

            team = super().update_unlocked(db_obj=team, obj_in=obj_in)

        self.update_classification(db=db)
        db.refresh(team)
        return team

    def add_checkpoint(
        self, db: Session, team: Team, checkpoint_id: int, obj_in: StaffScoresTeamUpdate
    ) -> Team:
        time = datetime.now()
        # can only update when no scores have been done
        if len(team.times) != checkpoint_id - 1:
            raise APIException(
                status_code=400, detail="Checkpoint not in order, or already passed"
            )

        team.question_scores.append(obj_in.question_score)
        team.time_scores.append(obj_in.time_score)
        team.pukes.append(obj_in.pukes)
        team.skips.append(obj_in.skips)
        team.times.append(time)

        # add cards randomly
        pity = len(team.times) == 7
        chance = random.random() > 0.6
        if chance or pity:
            for card in random.sample(("card1", "card2", "card3"), 3):
                if getattr(team, card) == -1:
                    setattr(team, card, 0)
                    if chance:
                        break

        db.add(team)
        db.commit()
        self.update_classification(db=db)
        db.refresh(team)
        return team

    def activate_cards_unlocked(
        self, *, team: Team, checkpoint_id: int, obj_in: StaffCardsTeamUpdate
    ) -> Team:
        # can only activate after scores have been done
        if len(team.times) != checkpoint_id:
            raise APIException(
                status_code=400, detail="Checkpoint not in order, or already passed"
            )

        # question pass
        if obj_in.card1 is not None:
            if team.card1 != 0:
                raise CardNotActiveException()
            if team.question_scores[-1]:
                raise CardEffectException()
            team.card1 = checkpoint_id
        # skip pass
        if obj_in.card2 is not None:
            if team.card2 != 0:
                raise CardNotActiveException()
            if team.skips[-1] <= 0:
                raise CardEffectException()
            team.card2 = checkpoint_id
        # puke pass
        if obj_in.card3 is not None:
            if team.card3 != 0:
                raise CardNotActiveException()
            if team.pukes[-1] <= 0:
                raise CardEffectException()
            team.card3 = checkpoint_id

        return team

    def activate_cards(
        self, db: Session, *, id: int, checkpoint_id: int, obj_in: StaffCardsTeamUpdate
    ) -> Team:
        with db.begin_nested():
            team = self.get(db=db, id=id, for_update=True)
            team = self.activate_cards_unlocked(
                team=team, checkpoint_id=checkpoint_id, obj_in=obj_in
            )
        self.update_classification(db=db)
        db.refresh(team)
        return team

    def get_by_checkpoint(self, db: Session, checkpoint_id: int) -> List[Team]:
        teams = self.get_multi(db=db)
        return [t for t in teams if len(t.times) == checkpoint_id]


team = CRUDTeam(Team)
