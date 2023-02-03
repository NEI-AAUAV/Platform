from datetime import datetime

from sqlalchemy import and_
from sqlalchemy.orm import Session

from app.crud.base import CRUDBase
from app.models.partner import Partner
from app.schemas.partner import PartnerCreate, PartnerUpdate


class CRUDPartner(CRUDBase[Partner, PartnerCreate, PartnerUpdate]):

    def get_banner(self, db: Session) -> Partner:
        """
        Select the first one that will end sooner
        """
        return db.query(Partner).order_by(Partner.banner_until)\
            .filter(and_(Partner.banner_until > datetime.now(),
                         Partner.banner_image != None,
                         Partner.banner_url != None)).first()


partner = CRUDPartner(Partner)
