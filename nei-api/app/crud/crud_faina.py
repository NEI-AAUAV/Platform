from app.crud.base import CRUDBase
from app.models.faina import Faina
from app.schemas.faina import FainaCreate, FainaUpdate


class CRUDFaina(CRUDBase[Faina, FainaCreate, FainaUpdate]):
    ...


faina = CRUDFaina(Faina)
