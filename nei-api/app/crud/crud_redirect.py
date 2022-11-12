from sqlalchemy.orm import Session

from app.crud.base import CRUDBase
from app.models.redirect import Redirect
from app.schemas.redirect import RedirectInDB, RedirectCreate, RedirectUpdate
from app.core.config import Settings
from typing import List


class CRUDRedirect(CRUDBase[Redirect, RedirectCreate, RedirectUpdate]):

    def get_redirect(self, db: Session, alias: str) -> RedirectInDB:
        """
        Return redirect url.
        """
        return db.query(Redirect).filter(Redirect.alias == alias).first()


redirect = CRUDRedirect(Redirect)