from typing import List

from sqlalchemy import func
from sqlalchemy.orm import Session, contains_eager

from app.crud.base import ReadOnlyCRUDBase
from app.models.rgm import Rgm
from app.models.rgm_mandate import RgmMandate

# The mandate is the related rgm_mandate label; the legacy text column is
# only a fallback for rows not yet linked.
_MANDATE = func.coalesce(RgmMandate.label, Rgm._mandate)


class CRUDRgm(ReadOnlyCRUDBase[Rgm]):

    def get_by(self, db: Session, category: str | None = None, mandate: str | None = None) -> List[Rgm]:
        # contains_eager reuses this join: RgmInDB.mandate reads mandate_ref,
        # which would otherwise be one extra query per row.
        query = (
            db.query(Rgm)
            .outerjoin(RgmMandate, Rgm.mandate_id == RgmMandate.id)
            .options(contains_eager(Rgm.mandate_ref))
        )
        if category:
            query = query.filter(Rgm.category == category)
        if mandate:
            query = query.filter(_MANDATE == mandate)
        return query.order_by(Rgm.date.desc().nullslast(), Rgm.id).all()

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
