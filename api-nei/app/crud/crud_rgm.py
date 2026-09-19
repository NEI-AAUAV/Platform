from typing import List
from sqlalchemy import func
from sqlalchemy.orm import Session

from app.crud.base import CRUDBase
from app.models.rgm import Rgm
from app.models.rgm_mandate import RgmMandate
from app.schemas.rgm import RgmCreate, RgmUpdate

# The mandate is the related rgm_mandate label; the legacy text column is
# only a fallback for rows not yet linked.
_MANDATE = func.coalesce(RgmMandate.label, Rgm._mandate)


class CRUDRgm(CRUDBase[Rgm, RgmCreate, RgmUpdate]):

    def get_by(self, db: Session, category: str | None = None, mandate: str | None = None) -> List[Rgm]:
        query = db.query(Rgm).outerjoin(RgmMandate, Rgm.mandate_id == RgmMandate.id)
        if category:
            query = query.filter(Rgm.category == category)
        if mandate:
            query = query.filter(_MANDATE == mandate)
        return query.all()

    def get_mandates(self, db: Session) -> List[str]:
        rows = (
            db.query(_MANDATE)
            .select_from(Rgm)
            .outerjoin(RgmMandate, Rgm.mandate_id == RgmMandate.id)
            .distinct()
            .all()
        )
        return [e[0] for e in rows if e[0]]


rgm = CRUDRgm(Rgm)
