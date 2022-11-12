
from sqlalchemy.orm import Session

from app.crud.base import CRUDBase
from app.models.history import History
from app.schemas.history import HistoryCreate, HistoryUpdate, HistoryInDB

from typing import List

class CRUDHistory(CRUDBase[History, HistoryCreate, HistoryUpdate]):

    def get_all(self, db: Session) -> List[HistoryInDB]:
        return db.query(History).all()


history = CRUDHistory(History)
