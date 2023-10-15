from typing import Any
from fastapi.encoders import jsonable_encoder
from pydantic import validate_model
from sqlalchemy.orm import Session

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
                update_data = obj_in.dict(exclude_unset=True)

            if "number" in update_data:
                number = update_data.pop("number")
                competition = self.update_number(
                    db, competition=competition, number=number
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
