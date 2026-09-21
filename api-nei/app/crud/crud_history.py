
from app.crud.base import CRUDBase
from app.models.history import History
from app.schemas.history import HistoryCreate, HistoryUpdate
from sqlalchemy import select
from sqlalchemy.orm import Session
from typing import Sequence


class CRUDHistory(CRUDBase[History, HistoryCreate, HistoryUpdate]):
    def get_multi(self, db: Session, **_: object) -> Sequence[History]:
        statement = select(History).order_by(History.moment.desc(), History.id.desc())
        return db.scalars(statement).all()


history = CRUDHistory(History)
