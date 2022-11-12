from typing import List
from sqlalchemy.orm import Session

from app.crud.base import CRUDBase
from app.models.merchandisings import Merchandisings
from app.schemas.merchandisings import MerchandisingsCreate, MerchandisingsUpdate, MerchandisingsInDB


class CRUDMerchandisings(CRUDBase[Merchandisings, MerchandisingsCreate, MerchandisingsUpdate]):
    def get_all(self, db: Session) -> List[MerchandisingsInDB]:
        return db.query(Merchandisings).all()



merchandisings = CRUDMerchandisings(Merchandisings)
