from sqlalchemy.orm import Session
from sqlalchemy import and_

from app.crud.base import CRUDBase
from app.models.seniors import Seniors
from app.schemas.seniors import SeniorsCreate, SeniorsUpdate


class CRUDSeniors(CRUDBase[Seniors, SeniorsCreate, SeniorsUpdate]):

    def get(self, db: Session, year: int, course: str) -> Seniors:
        """
        Return redirect url.
        """
        return db.query(Seniors).filter(and_(Seniors.year==year, Seniors.course==course)).first()


seniors = CRUDSeniors(Seniors)
