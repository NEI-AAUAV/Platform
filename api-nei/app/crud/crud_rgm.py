from typing import List
from sqlalchemy.orm import Session

from app.crud.base import CRUDBase
from app.models.rgm import Rgm
from app.schemas.rgm import RgmCreate, RgmUpdate


class CRUDRgm(CRUDBase[Rgm, RgmCreate, RgmUpdate]):

    def get_by(self, db: Session, category: str) -> List[Rgm]:
        return db.query(Rgm).filter(Rgm.category== category).all()


rgm = CRUDRgm(Rgm)
