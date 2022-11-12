from typing import List
from sqlalchemy.orm import Session

from app.crud.base import CRUDBase
from app.models.partners import Partners
from app.schemas.partners import PartnersCreate, PartnersUpdate, PartnersInDB


class CRUDPartners(CRUDBase[Partners, PartnersCreate, PartnersUpdate]):
    def get_all(self, db: Session) -> List[PartnersInDB]:
        return db.query(Partners).all()



partners = CRUDPartners(Partners)
