from app.crud.base import CRUDBase
from app.models.merch import Merch
from app.schemas.merch import MerchCreate, MerchUpdate


class CRUDMerch(CRUDBase[Merch, MerchCreate, MerchUpdate]):
    
    def get_by_discontinued(self, db, *, discontinued: bool) -> Merch:
        return db.query(Merch).filter(Merch.discontinued == discontinued).all()


merch = CRUDMerch(Merch)
