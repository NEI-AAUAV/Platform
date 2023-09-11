from fastapi.encoders import jsonable_encoder
from sqlalchemy.orm import Session

import app.crud as crud
from app.crud.base import CRUDBase
from app.exception import NotFoundException
from app.schemas.competition import CompetitionCreate, CompetitionUpdate
from app.models.competition import Competition
from app.core.logging import logger


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
        self, db: Session, *, id: int, obj_in: CompetitionUpdate | dict[str, any]
    ) -> Competition:
        db_obj = self.get(db, id=id)
        obj_data = jsonable_encoder(db_obj)
        if isinstance(obj_in, dict):
            update_data = obj_in
        else:
            update_data = obj_in.dict(exclude_unset=True)

        if "number" in update_data:
            number = update_data.pop("number")
            db_obj = self.update_number(db, db_obj=db_obj, number=number)

        for field in obj_data:
            if field in update_data:
                setattr(db_obj, field, update_data[field])
        db.add(db_obj)
        db.commit()
        db.refresh(db_obj)
        return db_obj
    
    def update_number(self, db: Session, *, db_obj: Competition, number: int) -> Competition:
        """Swap the order of two competitions."""
        db_obj2 = (
            db.query(Competition)
            .filter(
                Competition.modality_id == db_obj.modality_id, Competition.number == number
            )
            .one_or_none()
        )
        if not db_obj2:
            raise NotFoundException(f"Exchange Competition Not Found")
        setattr(db_obj, "number", number)
        setattr(db_obj2, "number", db_obj.number)
        db.add(db_obj)
        db.add(db_obj2)
        db.commit()
        db.refresh(db_obj)
        return db_obj


competition = CRUDCompetition(Competition)
