from app.crud.base import CRUDBase
from app.models.partner import Partner
from app.schemas.partner import PartnerCreate, PartnerUpdate
from sqlalchemy import select
from sqlalchemy.orm import Session
from typing import Sequence


class CRUDPartner(CRUDBase[Partner, PartnerCreate, PartnerUpdate]):
    def get_multi(self, db: Session, **_: object) -> Sequence[Partner]:
        statement = select(Partner).order_by(Partner.company, Partner.id)
        return db.scalars(statement).all()


partner = CRUDPartner(Partner)
