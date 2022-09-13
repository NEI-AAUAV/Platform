from sqlalchemy.orm import Session, noload
from typing import List

from app.crud.base import CRUDBase
from app.models.modality import Modality


class CRUDModality(CRUDBase[Modality, None, None]):
    
    def get_multi_noload(self, db: Session, *, skip: int = None, limit: int = None) -> List[Modality]:
        return db.query(self.model).options(noload('*')).offset(skip).limit(limit).all()


modality = CRUDModality(Modality)
