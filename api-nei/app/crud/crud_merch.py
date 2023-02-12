from app.crud.base import CRUDBase
from app.models.merch import Merch
from app.schemas.merch import MerchCreate, MerchUpdate


class CRUDMerch(CRUDBase[Merch, MerchCreate, MerchUpdate]):
    ...


merch = CRUDMerch(Merch)
