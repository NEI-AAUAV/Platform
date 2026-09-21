from app.crud.base import CRUDBase
from app.models.merch import Merch
from app.schemas.merch import MerchCreate, MerchUpdate
from sqlalchemy import select
from sqlalchemy.orm import Session
from typing import Sequence


class CRUDMerch(CRUDBase[Merch, MerchCreate, MerchUpdate]):
    
    def get_by_discontinued(
        self, db: Session, *, discontinued: bool
    ) -> Sequence[Merch]:
        stmt = (
            select(Merch)
            .where(Merch.discontinued.is_(discontinued))
            .order_by(Merch.name, Merch.id)
        )
        return db.scalars(stmt).all()


merch = CRUDMerch(Merch)
