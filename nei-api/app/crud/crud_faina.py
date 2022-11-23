from sqlalchemy.orm import Session

from app.crud.base import CRUDBase, ModelType
from app.models.faina import Faina
from app.schemas.faina import FainaCreate, FainaUpdate

from typing import List, Optional

from datetime import datetime


class CRUDFaina(CRUDBase[Faina, FainaCreate, FainaUpdate]):
    def get_faina(self, db: Session, mandato: int) -> Optional[ModelType]:
        return db.query(self.model).filter(self.model.mandato == mandato).first()

faina = CRUDFaina(Faina)
