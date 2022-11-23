from app.crud.base import CRUDBase
from app.models.partners import Partners
from app.schemas.partners import PartnersCreate, PartnersUpdate


class CRUDPartners(CRUDBase[Partners, PartnersCreate, PartnersUpdate]):
    ...


partners = CRUDPartners(Partners)
