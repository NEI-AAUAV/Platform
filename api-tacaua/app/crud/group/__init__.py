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

    def lock_for_teams_update(self, db: Session) -> None:
        db.execute(
            sqlalchemy.text(
                f"LOCK TABLE ONLY {settings.SCHEMA_NAME}.{Match.__tablename__}, {settings.SCHEMA_NAME}.{Team.__tablename__} IN EXCLUSIVE MODE;"
            )
        )

    def update(
        self, db: Session, *, id: int, obj_in: Union[GroupUpdate, Dict[str, Any]]
    ) -> Group:
        with db.begin_nested():
            # Lock the matches and teams tables to prevent updates
            # (read queries with no update intention are still allowed).
            self.lock_for_teams_update(db)

            # Load the group with a `FOR UPDATE` lock to ensure it isn't changed while we are making changes
            # and that other queries that need to ensure integrity of keys don't read it while we modify it.
            # NOTE: The loading of the `match` must be deferred since postgres doesn't support `FOR UPDATE`
            #       queries with `JOIN`s.
            group = self.get(db, id=id, with_for="update", defer=[Group.matches])
            # Ensure `update_data` is a dict, converting it from the update schema if needed.
            if isinstance(obj_in, dict):
                update_data = obj_in
            else:
                update_data = obj_in.model_dump(exclude_unset=True)

            # If the number is to be changed, a special operation needs to be performed
            # in order to swap the number with the group that currently has that number.
            if "number" in update_data:
                number = update_data.pop("number")
                group = self.update_number(db, group=group, number=number)

            # If the teams belonging to the group are changed the matches may need to be
            # updated
            if "teams_id" in update_data:
                teams_id = update_data["teams_id"]
                # Get the competition the group belongs to, locking it with `FOR SHARE` to
                # make sure it isn't updated while we are using it, we won't update it so the
                # weaker suffices.
                competition = crud.competition.get(
                    db,
                    id=group.competition_id,
                    with_for="share",
                    raise_load=[Competition.groups],
                )
                group = self.update_teams(
                    db, group=group, teams_id=teams_id, competition=competition
                )

            # Convert the model to JSON to allow iteration trough the keys
            for field in jsonable_encoder(group):
                if field in update_data:
                    setattr(group, field, update_data[field])

        # Refresh the matches after the transaction to ensure
        # the new changes are fetched.
        db.refresh(group)
        return group

    def update_number(self, db: Session, *, group: Group, number: int) -> Group:
        """Swap the order of two groups."""
        # Get the group that currently has the number to be swapped in the same
        # competition as the group being updated.
        swap_group = (
            db.query(Group)
            .filter(
                Group.competition_id == group.competition_id, Group.number == number
            )
            # Make sure the most up to date values are used
            .populate_existing()
            # Get a lock on the group to ensure it isn't modified at the same time
            .with_for_update()
            .one_or_none()
        )
        if not swap_group:
            raise NotFoundException(f"Exchange Group Not Found")
        # Swap the number of the groups
        group.number = number
        swap_group.number = group.number
        return group

    def update_teams(
        self, db: Session, *, group: Group, teams_id: Set[int], competition: Competition
    ) -> Group:
        """Update the matches in a group when the teams are updated.

        This ensures consistency between the matches and the teams.
        Matches are created according to the competition system.
        """
        # Get the teams that are already in the group and are in the update data
        teams = [t for t in group.teams if t.id in teams_id]
        # Calculate the ids of the new teams (if there are any)
        teams_id_diff = set(teams_id) - {t.id for t in teams}

        # Fetch the modified teams, no lock is needed since the table lock is held
        teams_diff: List[Team] = (
            db.query(Team)
            .filter(
                Team.id.in_(teams_id_diff), Team.modality_id == competition.modality_id
            )
            .all()
        )

        # Check that all teams exist by ensuring the length of the loaded teams
        # is equal to the length of the set of modified IDs.
        #
        # This works because the IDs are unique so there's a 1-to-1 mapping between
        # the number of rows and the number of distinct IDs.
        if len(teams_diff) != len(teams_id_diff):
            raise NotFoundException(detail=f"Team In Modality Not Found")

        # Update the group's teams
        group.teams = teams + teams_diff

        # Update matches according to system
        print(competition._metadata)
        metadata = Metadata.model_validate(competition._metadata).root
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
