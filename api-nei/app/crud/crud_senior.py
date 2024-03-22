from typing import List, Optional

from sqlalchemy import select
from sqlalchemy.orm import Session

from app.crud.base import CRUDBase
from app.models.senior import Senior
from app.schemas.senior import SeniorCreate, SeniorUpdate


class CRUDSenior(CRUDBase[Senior, SeniorCreate, SeniorUpdate]):
    def get_course(self, db: Session) -> List[str]:
        stmt = select(Senior.course).distinct()
        return db.scalars(stmt).all()

    def get_course_year(self, db: Session, *, course: str) -> List[int]:
        stmt = select(Senior.year).where(Senior.course == course).distinct()
        return db.scalars(stmt).all()

    def get_by(self, db: Session, *, year: int, course: str) -> Optional[Senior]:
        """
        Return redirect url.
        """
        stmt = select(Senior).where(Senior.year == year, Senior.course == course)
        return db.scalars(stmt).one_or_none()


senior = CRUDSenior(Senior)
