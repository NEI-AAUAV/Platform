import math
from typing import Union, Dict, Any, Set, List
from fastapi.encoders import jsonable_encoder
from sqlalchemy.orm import Session

import app.crud as crud
from app.exception import NotFoundException, NotImplementedException
from app.crud.base import CRUDBase
from app.schemas.competition import (
    Metadata, SingleElimination, RoundRobin, Swiss)
from app.schemas.group import GroupCreate, GroupUpdate
from app.schemas.match import MatchCreate
from app.models import Group, Team, Match
from app.core.logging import logger


class CRUDGroup(CRUDBase[Group, GroupCreate, GroupUpdate]):

    def create(self, db: Session, *, obj_in: GroupCreate) -> Group:
        obj_in_data = jsonable_encoder(obj_in)
        db_obj = Group(**obj_in_data)
        count = db.query(Group).filter(
            Group.competition_id == db_obj.competition_id).count()
        setattr(db_obj, 'number', count + 1)
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
        teams_id_diff = set(teams_id) - {t.id for t in teams}

        if len(teams) == len(db_obj.teams) and not teams_id_diff:
            # Nothing to update
            return db_obj

        # Assign new teams to group
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

        # Update matches according to system
        metadata = crud.competition.get(
            db, id=db_obj.competition_id).metadata_
        metadata = Metadata.parse_obj(metadata).__root__
        if isinstance(metadata, SingleElimination):
            f = self.update_single_elimination
        elif isinstance(metadata, RoundRobin):
            f = self.update_round_robin
        elif isinstance(metadata, Swiss):
            f = self.update_swiss
        else:
            raise NotImplementedException()
        f(db, db_obj, metadata)

        return db_obj

    def update_single_elimination(
        self, db: Session, group: Group, metadata: SingleElimination
    ) -> None:
        """Recreate match bracket."""
        # TODO: not using metadata for 3rd match

        matches = db.query(Match).filter(Match.group_id == group.id).all()
        teams_id = {t.id for t in group.teams}
        savepoint = db.begin_nested()
        try:
            for m in matches[:]:
                # Delete matches without both teams
                # or with teams out of group
                if not teams_id.issuperset((m.team1_id, m.team2_id)):
                    matches.remove(m)
                    db.delete(m)
                    db.commit()

            teams_id_assigned = {tid for m in matches
                                 for tid in (m.team1_id, m.team2_id) if tid}
            teams_id_diff = teams_id - teams_id_assigned

            matches_count_per_round = self.get_matches_per_round(
                len(group.teams))
            matches_per_round = [[] for _ in range(
                len(matches_count_per_round))]

            for r, matches_count in enumerate(matches_count_per_round):
                for _ in range(matches_count):
                    if matches:
                        # Add leaf match
                        m = matches.pop()
                        m.round = r + 1
                    else:
                        # Create match
                        match_data = {'group_id': group.id, 'round': r + 1}
                        if teams_id_diff:
                            tid1 = teams_id_diff.pop()
                            match_data |= {'team1_id': tid1}
                            if teams_id_diff:
                                # Create leaf match
                                tid2 = teams_id_diff.pop()
                                match_data |= {'team2_id': tid2}
                            else:
                                # Create next match for 1 previous match
                                c = matches_count_per_round[r - 1]
                                m = matches_per_round[r - 1][c - 1]
                                match_data |= {
                                    'team2_prereq_match_id': m.id
                                }
                                matches_count_per_round[r - 1] -= 1
                        else:
                            # Create next match for 2 previous matches
                            c = matches_count_per_round[r - 1]
                            ms = matches_per_round[r - 1]
                            match_data |= {
                                'team1_prereq_match_id': ms[c - 1].id,
                                'team2_prereq_match_id': ms[c - 2].id
                            }
                            matches_count_per_round[r - 1] -= 2
                        m = Match(**match_data)
                    db.add(m)
                    matches_per_round[r].append(m)
        except Exception as e:
            # Perhaps database has an unexpected state
            savepoint.rollback()
            logger.error(e)
        db.commit()
        

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

    def get_matches_per_round(self, n_teams: int) -> List[int]:
        if n_teams < 1:
            return []
        n = int(math.log2(n_teams))
        matches_per_round = [2**i for i in reversed(range(n))]
        matches_diff = n_teams - sum(matches_per_round) - 1
        if matches_diff:
            matches_per_round = [matches_diff] + matches_per_round
        return matches_per_round


group = CRUDGroup(Group)
