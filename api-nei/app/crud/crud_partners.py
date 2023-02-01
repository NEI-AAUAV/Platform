from datetime import datetime

from sqlalchemy import and_
from sqlalchemy.orm import Session

from app.crud.base import CRUDBase
from app.models.partners import Partners
from app.schemas.partners import PartnersCreate, PartnersUpdate


class CRUDPartners(CRUDBase[Partners, PartnersCreate, PartnersUpdate]):

    def get_banner(self, db: Session) -> Partners:
        """
        Select the first one that will end sooner
        """
        return db.query(Partners).order_by(Partners.banner_until)\
            .filter(and_(Partners.banner_until > datetime.now(),
                         Partners.banner_image != None,
                         Partners.banner_url != None)).first()


partners = CRUDPartners(Partners)
