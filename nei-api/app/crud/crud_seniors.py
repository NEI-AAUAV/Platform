from typing import List

from sqlalchemy.orm import Session
from sqlalchemy import and_

from app.crud.base import CRUDBase
from app.models.seniors import Seniors
from app.schemas.seniors import SeniorsCreate, SeniorsUpdate


class CRUDSeniors(CRUDBase[Seniors, SeniorsCreate, SeniorsUpdate]):

    def get_course(self, db: Session) -> List[str]:
        return [s.course for s in db.query(Seniors.course).distinct()]

    def get_course_year(self, db: Session, *, course: str) -> List[int]:
        return [s.year for s in db.query(Seniors.year).filter(Seniors.course == course).distinct()]

    def get_by(self, db: Session, *, year: int, course: str) -> Seniors:
        """
        Return redirect url.
        """
        return db.query(Seniors)\
            .filter(and_(Seniors.year == year, Seniors.course == course)).one_or_none()


seniors = CRUDSeniors(Seniors)
