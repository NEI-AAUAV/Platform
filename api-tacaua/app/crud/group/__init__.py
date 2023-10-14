import sqlalchemy
from typing import Union, Dict, Any, Set, List
from fastapi.encoders import jsonable_encoder
from sqlalchemy.orm import Session

import app.crud as crud
from app.core.config import settings
from app.exception import NotFoundException, NotImplementedException
from app.crud.base import CRUDBase
from app.models.competition import Competition
from app.schemas.competition import Metadata, SingleElimination, RoundRobin, Swiss
from app.schemas.group import GroupCreate, GroupUpdate
from app.models import Group, Team, Match

from .swiss import update_swiss_matches
from .round_robin import update_round_robin_matches
from .single_elimination import update_single_elimination_matches


class CRUDGroup(CRUDBase[Group, GroupCreate, GroupUpdate]):
    def create(self, db: Session, *, obj_in: GroupCreate) -> Group:
        obj_in_data = jsonable_encoder(obj_in)
        db_obj = Group(**obj_in_data)
        count = (
            db.query(Group)
            .filter(Group.competition_id == db_obj.competition_id)
            .count()
        )
        setattr(db_obj, "number", count + 1)
        db.add(db_obj)
        db.commit()
        db.refresh(db_obj)
        return db_obj

    def update(
        self, db: Session, *, id: int, obj_in: Union[GroupUpdate, Dict[str, Any]]
    ) -> Group:
        with db.begin_nested():
            # Lock the matches and teams tables to prevent updates
            # (read queries with no update intention are still allowed).
            db.execute(
                sqlalchemy.text(
                    f"LOCK TABLE ONLY {settings.SCHEMA_NAME}.{Match.__tablename__}, {settings.SCHEMA_NAME}.{Team.__tablename__} IN EXCLUSIVE MODE;"
                )
            )

            group = self.get(db, id=id, update=True, defer=[Group.matches])
            obj_data = jsonable_encoder(group)
            if isinstance(obj_in, dict):
                update_data = obj_in
            else:
                update_data = obj_in.dict(exclude_unset=True)

            if "number" in update_data:
                number = update_data.pop("number")
                group = self.update_number(db, group=group, number=number)
            if "teams_id" in update_data:
                teams_id = update_data["teams_id"]
                group = self.update_teams(db, group=group, teams_id=teams_id)

            for field in obj_data:
                if field in update_data:
                    setattr(group, field, update_data[field])

        db.refresh(group, attribute_names=["matches"])
        return group

    def update_number(self, db: Session, *, group: Group, number: int) -> Group:
        """Swap the order of two groups."""
        swap_group = (
            db.query(Group)
            .filter(
                Group.competition_id == group.competition_id, Group.number == number
            )
            .populate_existing()
            .with_for_update()
            .one_or_none()
        )
        if not swap_group:
            raise NotFoundException(f"Exchange Group Not Found")
        setattr(group, "number", number)
        setattr(swap_group, "number", group.number)
        return group

    def update_teams(self, db: Session, *, group: Group, teams_id: Set[int]) -> Group:
        """Update the matches in a group when the teams are updated.

        This ensures consistency between the matches and the teams.
        Matches are created according to the competition system.
        """
        competition = crud.competition.get(
            db, id=group.competition_id, update=True, raise_load=[Competition.groups]
        )
        teams = [t for t in group.teams if t.id in teams_id]
        teams_id_diff = set(teams_id) - {t.id for t in teams}

        if len(teams) == len(group.teams) and not teams_id_diff:
            # Nothing to update
            return group

        teams_diff: List[Team] = (
            db.query(Team)
            .filter(
                Team.id.in_(teams_id_diff), Team.modality_id == competition.modality_id
            )
            .all()
        )

        if len(teams_diff) != len(teams_id_diff):
            raise NotFoundException(detail=f"Team In Modality Not Found")

        teams += teams_diff
        group.teams = teams

        # Update matches according to system
        metadata = Metadata.parse_obj(competition._metadata).__root__
        if isinstance(metadata, SingleElimination):
            update_single_elimination_matches(db, group, metadata)
        elif isinstance(metadata, RoundRobin):
            update_round_robin_matches(db, group, metadata)
        elif isinstance(metadata, Swiss):
            update_swiss_matches(db, group, metadata)
        else:
            raise NotImplementedException()

        return group


group = CRUDGroup(Group)
