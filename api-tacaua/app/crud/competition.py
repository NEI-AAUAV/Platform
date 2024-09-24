from typing import Any

from sqlalchemy.orm import Session
from fastapi.encoders import jsonable_encoder

import app.crud as crud
from app.crud.base import CRUDBase
from app.exception import NotFoundException
from app.models.competition import Competition
from app.schemas.competition import CompetitionCreate, CompetitionUpdate, Metadata


class CRUDCompetition(CRUDBase[Competition, CompetitionCreate, CompetitionUpdate]):
    def create(self, db: Session, *, obj_in: CompetitionCreate) -> Competition:
        obj_in_data = jsonable_encoder(obj_in)
        db_obj = self.model(**obj_in_data)
        count = (
            db.query(Competition)
            .filter(Competition.modality_id == db_obj.modality_id)
            .count()
        )
        setattr(db_obj, "number", count + 1)
        db.add(db_obj)
        db.commit()
        db.refresh(db_obj)

        # Every competition must have at least one group
        crud.group.create(db, obj_in={"competition_id": db_obj.id})

        return db_obj

    def update(
        self, db: Session, *, id: int, obj_in: CompetitionUpdate | dict[str, Any]
    ) -> Competition:
        with db.begin_nested():
            competition = self.get(
                db, id=id, with_for="update", defer=[Competition.groups]
            )

            if isinstance(obj_in, dict):
                update_data = obj_in
            else:
                update_data = obj_in.model_dump(exclude_unset=True)

            if "number" in update_data:
                number = update_data.pop("number")
                competition = self.update_number(
                    db, competition=competition, number=number
                )

            if "_metadata" in update_data:
                metadata = update_data.pop("_metadata")

                if (
                    not ("system" in metadata)
                    or competition._metadata["system"] == metadata.system
                ):
                    metadata["system"] = competition._metadata["system"]
                    Metadata.model_validate(metadata)
                    for field in jsonable_encoder(competition._metadata):
                        if field in metadata:
                            # `setattr` can't be used here, because the JSON field is a
                            # `MutableDict` and `setattr` bypasses the state tracking
                            # causing the value to not be changed.
                            competition._metadata[field] = metadata[field]
                else:
                    Metadata.model_validate(metadata)
                    competition._metadata = metadata

                # Make sure the metadata is updated so that the Group's update routines
                # can see the fresh data.
                db.flush([competition])
                crud.group.lock_for_teams_update(db)

                for group in competition.groups:
                    teams_id = {t.id for t in group.teams}
                    crud.group.update_teams(
                        db, group=group, teams_id=teams_id, competition=competition
                    )

            for field in jsonable_encoder(competition):
                if field in update_data:
                    setattr(competition, field, update_data[field])

        db.refresh(competition)
        return competition

    def update_number(
        self, db: Session, *, competition: Competition, number: int
    ) -> Competition:
        """Swap the order of two competitions."""
        swap_competition = (
            db.query(Competition)
            .filter(
                Competition.modality_id == competition.modality_id,
                Competition.number == number,
            )
            .populate_existing()
            .with_for_update()
            .one_or_none()
        )
        if not swap_competition:
            raise NotFoundException(f"Exchange Competition Not Found")
        competition.number = number
        swap_competition.number = competition.number
        return competition


competition = CRUDCompetition(Competition)
