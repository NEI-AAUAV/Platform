from fastapi.encoders import jsonable_encoder
from sqlalchemy.orm import Session
from app.crud.base import CRUDBase
from app.schemas.competition import SystemEnum, CompetitionCreate
from app.models.competition import Competition
from app.utils import Ignore


class CRUDCompetition(CRUDBase[Competition, Ignore, Ignore]):  # TODO: ignore does work ig

    def create(self, db: Session, *, obj_in: CompetitionCreate) -> Competition:
        obj_in_data = jsonable_encoder(obj_in)
        db_obj = self.model(**obj_in_data)
        db.add(db_obj)
        db.commit()

        # if db_obj.system == SystemEnum.SINGLE_ELIMINATION:
    

        db.refresh(db_obj)
        return db_obj


competition = CRUDCompetition(Competition)
