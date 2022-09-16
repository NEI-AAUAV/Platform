from typing import List

from sqlalchemy.orm import Session, noload
from app.crud.base import CRUDBase
from app.schemas.modality import ModalityCreate, ModalityUpdate
from app.models.modality import Modality


class CRUDModality(CRUDBase[Modality, ModalityCreate, ModalityUpdate]):
    
    def get_multi(self, db: Session, *, skip: int = None, limit: int = None) -> List[Modality]:
        return db.query(self.model).options(noload('*')).offset(skip).limit(limit).all()


modality = CRUDModality(Modality)
