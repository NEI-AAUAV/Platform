from typing import Optional, Sequence

from sqlalchemy import select
from sqlalchemy.orm import Session, joinedload, selectinload

from app.crud.base import CRUDBase
from app.models.history import History
from app.schemas.history import HistoryCreate, HistoryUpdate


class CRUDHistory(CRUDBase[History, HistoryCreate, HistoryUpdate]):
    def get_multi(self, db: Session, **_: object) -> Sequence[History]:
        statement = (
            select(History)
            .where(History.published.is_(True))
            .options(selectinload(History.media), joinedload(History.category))
            .order_by(History.moment.desc(), History.id.desc())
        )
        return db.scalars(statement).all()

    def get_published(self, db: Session, id: int) -> Optional[History]:
        statement = (
            select(History)
            .where(History.id == id, History.published.is_(True))
            .options(selectinload(History.media), joinedload(History.category))
        )
        return db.scalars(statement).first()


history = CRUDHistory(History)
