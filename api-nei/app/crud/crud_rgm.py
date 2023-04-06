from typing import List
from sqlalchemy.orm import Session

from app.crud.base import CRUDBase
from app.models.rgm import Rgm
from app.schemas.rgm import RgmCreate, RgmUpdate


class CRUDRgm(CRUDBase[Rgm, RgmCreate, RgmUpdate]):

    def get_by(self, db: Session, category: str | None = None, mandate: str | None = None) -> List[Rgm]:
        query = db.query(Rgm)
        if category:
            query = query.filter(Rgm.category == category)
        if mandate:
            query = query.filter(Rgm.mandate == mandate)
        return query.all()
    
    def get_mandates(self, db: Session) -> List[str]:
        return [e[0] for e in db.query(Rgm.mandate).distinct().all()]
      


rgm = CRUDRgm(Rgm)
