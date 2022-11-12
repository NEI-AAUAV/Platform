from typing import List, Optional
from sqlalchemy.orm import Session

from app.crud.base import CRUDBase
from app.models.rgm import Rgm
from app.schemas.rgm import RgmCreate, RgmUpdate, RgmInDB


class CRUDRgm(CRUDBase[Rgm, RgmCreate, RgmUpdate]):
    def get_by(self, db: Session, category: str) -> List[Rgm]:
        return db.query(self.model).filter(self.model.categoria== category).all()


rgm = CRUDRgm(Rgm)
