from fastapi.encoders import jsonable_encoder
from sqlalchemy.orm import Session

import app.crud as crud
from app.crud.base import CRUDBase
from app.schemas.competition import CompetitionCreate
from app.models.competition import Competition
from app.utils import Ignore
from app.core.logging import logger


class CRUDCompetition(CRUDBase[Competition, Ignore, Ignore]):

    def create(self, db: Session, *, obj_in: CompetitionCreate) -> Competition:
        obj_in_data = jsonable_encoder(obj_in)
        db_obj = self.model(**obj_in_data)
        db.add(db_obj)
        db.commit()
        db.refresh(db_obj)

        crud.group.create(db, obj_in={"competition_id": db_obj.id})

        return db_obj


competition = CRUDCompetition(Competition)
