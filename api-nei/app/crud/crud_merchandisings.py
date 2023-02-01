from app.crud.base import CRUDBase
from app.models.merchandisings import Merchandisings
from app.schemas.merchandisings import MerchandisingsCreate, MerchandisingsUpdate


class CRUDMerchandisings(CRUDBase[Merchandisings, MerchandisingsCreate, MerchandisingsUpdate]):
    ...


merchandisings = CRUDMerchandisings(Merchandisings)
