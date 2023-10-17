import math
import random
from typing import List, Sequence
from datetime import datetime
from fastapi import HTTPException
from sqlalchemy.exc import IntegrityError

from sqlalchemy.orm import Session

from app.exception import APIException, CardNotActiveException, CardEffectException
from app.crud.base import CRUDBase
from app.models.team import Team
from app.schemas.team import (
    TeamCreate,
    TeamUpdate,
    TeamScoresUpdate,
    TeamCardsUpdate,
)

from ._deps import unique_key_error_regex

locked_arrays = [
    "times",
    "question_scores",
    "time_scores",
    "pukes",
    "skips",
]

_name_unique_error_regex = unique_key_error_regex(Team.name.name)


class CRUDTeam(CRUDBase[Team, TeamCreate, TeamUpdate]):
    def calculate_min_time_scores(self, teams: Sequence[Team]) -> List[float]:
        all_time_scores = [
            t.time_scores + [0] * (8 - len(t.time_scores)) for t in teams
        ]

        min_time_scores = [
            min(map(lambda s: s if s != 0 else math.inf, scores))
            for scores in zip(*all_time_scores)
        ]

        return min_time_scores

    def calculate_checkpoint_score(
        self, checkpoint: int, *, team: Team, min_time_scores: List[float]
    ):
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

        return (
            calc_time_score(checkpoint, team.time_scores[checkpoint])
            + calc_question_scores(
                team.card1 == checkpoint + 1, team.question_scores[checkpoint]
            )
            + calc_skips(team.card2 == checkpoint + 1, team.skips[checkpoint])
            + calc_pukes(team.card3 == checkpoint + 1, team.pukes[checkpoint])
        )

    def update_classification_unlocked(self, db: Session):
        teams = list(self.get_multi(db=db, for_update=True))

        min_time_scores = self.calculate_min_time_scores(teams)

        for t in teams:
            t.total = sum(
                self.calculate_checkpoint_score(
                    i, team=t, min_time_scores=min_time_scores
                )
                for i in range(len(t.times))
            )

        teams.sort(key=lambda t: (-t.total, t.name))

        for i, team in enumerate(teams):
            team.classification = i + 1
            db.add(team)

    def update_classification(self, db: Session):
        with db.begin_nested():
            self.update_classification_unlocked(db)
            db.commit()

    def create(self, db: Session, *, obj_in: TeamCreate) -> Team:
        try:
            team = super().create(db, obj_in=obj_in)
        except IntegrityError as e:
            db.rollback()

            if e.orig is None:
                raise

            if _name_unique_error_regex.search(str(e.orig)) is not None:
                raise HTTPException(status_code=400, detail="Team name already exists")

            raise

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
            db.commit()

        self.update_classification(db=db)
        db.refresh(team)
        return team

    def add_checkpoint(
        self, db: Session, *, id: int, checkpoint_id: int, obj_in: TeamScoresUpdate
    ) -> Team:
        with db.begin_nested():
            team = self.get(db=db, id=id, for_update=True)

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

            db.commit()
        self.update_classification(db=db)
        db.refresh(team)
        return team

    def activate_cards_unlocked(
        self, *, team: Team, checkpoint_id: int, obj_in: TeamCardsUpdate
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
        self, db: Session, *, id: int, checkpoint_id: int, obj_in: TeamCardsUpdate
    ) -> Team:
        with db.begin_nested():
            team = self.get(db=db, id=id, for_update=True)
            team = self.activate_cards_unlocked(
                team=team, checkpoint_id=checkpoint_id, obj_in=obj_in
            )
            db.commit()
        self.update_classification(db=db)
        db.refresh(team)
        return team

    def get_by_checkpoint(self, db: Session, checkpoint_id: int) -> List[Team]:
        teams = self.get_multi(db=db)
        return [t for t in teams if len(t.times) == checkpoint_id]


team = CRUDTeam(Team)
