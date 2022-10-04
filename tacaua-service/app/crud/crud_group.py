import math
from typing import Union, Dict, Any, Set, List
from fastapi.encoders import jsonable_encoder
from sqlalchemy.orm import Session

import app.crud as crud
from app.exception import NotFoundException
from app.crud.base import CRUDBase
from app.schemas.competition import (
    Metadata, SingleElimination, RoundRobin, Swiss)
from app.schemas.group import GroupCreate, GroupUpdate
from app.schemas.match import MatchCreate
from app.models import Group, Team, Match
from app.core.logging import logger


class CRUDGroup(CRUDBase[Group, GroupCreate, GroupUpdate]):

    def get_matches_per_round(self, n_teams: int) -> List[int]:
        if n_teams < 1:
            return []
        n = int(math.log2(n_teams))
        matches_per_round = [2**i for i in reversed(range(n))]
        matches_diff = n_teams - sum(matches_per_round) - 1
        if matches_diff:
            matches_per_round = [matches_diff] + matches_per_round
        return matches_per_round

    def update_single_elimination(
        self, db: Session, group: Group, metadata: SingleElimination
    ) -> None:
        logger.debug(metadata.system)
        '''
        matches_per_round = self.get_matches_per_round(len(group.teams))
        n_rounds = len(matches_per_round)
        matches = [[] for _ in range(n)]

        rounds = db.query(Round).filter(Round.group_id == group.id).order_by(
            Round.number).all()

        n_rounds_diff = len(rounds) - n_rounds
        if n_rounds_diff > 0:
            # Delete rounds
            for r in range(n_rounds_diff):
                db.delete(rounds[r])
            rounds = rounds[n_rounds_diff:]
        elif n_rounds_diff < 0:
            # Create rounds
            rounds = [None]*abs(n_rounds_diff) + rounds

        for r in range(n_rounds):
            if n_rounds_diff != 0:
                if not rounds[r]:
                    # Create new round
                    obj_in = RoundCreate(number=r + 1)
                    rounds[r] = crud.round.create(db, obj_in=obj_in)
                else:
                    # Update existent round
                    rounds[r] = crud.round.update(db, {"number": r + 1})

            for m in range(matches_per_round[r]):
                match1_id = match2_id = None

                matches = db.query(Match).filter(
                    Match.round_id == rounds[r].id)

                if r > 0:
                    match1_id = match2_id

                obj_in = MatchCreate(round_id=round.id, team1_prereq_match_id=match1_id,
                                     team2_prereq_match_id=match2_id)
                match = crud.match.create(db, obj_in=obj_in)

                matches[r].append(match)
        '''
        ...

    def update_round_robin(
        self, db: Session, group: Group, metadata: RoundRobin
    ) -> None:
        logger.debug(metadata.system)
        ...

    def update_swiss(
        self, db: Session, group: Group, metadata: Swiss
    ) -> None:
        logger.debug(metadata.system)
        ...

    def create(self, db: Session, *, obj_in: GroupCreate) -> Group:
        obj_in_data = jsonable_encoder(obj_in)
        db_obj = Group(**obj_in_data)
        count = db.query(Group).filter(
            Group.competition_id == db_obj.competition_id).count()
        setattr(db_obj, 'number', count + 1)
        db.add(db_obj)
        db.commit()
        db.refresh(db_obj)

        metadata = crud.competition.get(
            db, id=db_obj.competition_id).metadata_
        metadata = Metadata.parse_obj(metadata).__root__

        if isinstance(metadata, SingleElimination):
            self.update_single_elimination(db, db_obj, metadata)
        elif isinstance(metadata, RoundRobin):
            self.update_round_robin(db, db_obj, metadata)
        elif isinstance(metadata, Swiss):
            self.update_swiss(db, db_obj, metadata)

        return db_obj

    def update_number(
        self, db: Session, *, db_obj: Group, number: int
    ) -> Group:
        db_obj2 = db.query(Group).filter(
            Group.competition_id == db_obj.competition_id,
            Group.number == number
        ).one_or_none()
        if not db_obj2:
            raise NotFoundException(f"Exchange Group Not Found")
        setattr(db_obj, 'number', number)
        setattr(db_obj2, 'number', db_obj.number)
        db.add(db_obj)
        db.add(db_obj2)
        db.commit()
        db.refresh(db_obj)
        return db_obj

    def update_teams(
        self, db: Session, *, db_obj: Group, teams_id: Set[int]
    ) -> Group:
        modality_id = crud.competition.get(
            db, id=db_obj.competition_id).modality_id
        teams = [t for t in db_obj.teams if t.id in teams_id]
        teams_id_diff = teams_id - {t.id for t in teams}
        for tid in teams_id_diff:
            team = db.query(Team).filter(
                Team.id == tid, Team.modality_id == modality_id).first()
            if not team:
                raise NotFoundException(detail=f"Team In Modality Not Found")
            teams.append(team)
        db_obj.teams = teams
        db.add(db_obj)
        db.commit()
        db.refresh(db_obj)
        return db_obj

    def update(
        self,
        db: Session,
        *,
        id: int,
        obj_in: Union[GroupUpdate, Dict[str, Any]]
    ) -> Group:
        db_obj = self.get(db, id=id)
        obj_data = jsonable_encoder(db_obj)
        if isinstance(obj_in, dict):
            update_data = obj_in
        else:
            update_data = obj_in.dict(exclude_unset=True)

        if 'number' in update_data:
            number = update_data.pop('number')
            db_obj = self.update_number(db, db_obj=db_obj, number=number)
        if 'teams_id' in update_data:
            teams_id = update_data['teams_id']
            db_obj = self.update_teams(db, db_obj=db_obj, teams_id=teams_id)

        for field in obj_data:
            if field in update_data:
                setattr(db_obj, field, update_data[field])
        db.add(db_obj)
        db.commit()
        db.refresh(db_obj)
        return db_obj


group = CRUDGroup(Group)
