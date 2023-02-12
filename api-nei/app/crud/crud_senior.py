from typing import List

from sqlalchemy.orm import Session
from sqlalchemy import and_

from app.crud.base import CRUDBase
from app.models.senior import Senior
from app.schemas.senior import SeniorCreate, SeniorUpdate


class CRUDSenior(CRUDBase[Senior, SeniorCreate, SeniorUpdate]):

    def get_course(self, db: Session) -> List[str]:
        return [s.course for s in db.query(Senior.course).distinct()]

    def get_course_year(self, db: Session, *, course: str) -> List[int]:
        return [s.year for s in db.query(Senior.year).filter(Senior.course == course).distinct()]

    def get_by(self, db: Session, *, year: int, course: str) -> Senior:
        """
        Return redirect url.
        """
        return db.query(Senior)\
            .filter(and_(Senior.year == year, Senior.course == course)).one_or_none()


senior = CRUDSenior(Senior)
