from datetime import datetime

from sqlalchemy import and_
from sqlalchemy.orm import Session

from app.crud.base import CRUDBase
from app.models.partner import Partner
from app.schemas.partner import PartnerCreate, PartnerUpdate


class CRUDPartner(CRUDBase[Partner, PartnerCreate, PartnerUpdate]):
    ...


partner = CRUDPartner(Partner)
