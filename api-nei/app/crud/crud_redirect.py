from sqlalchemy.orm import Session

from app.crud.base import CRUDBase
from app.models.redirect import Redirect
from app.schemas.redirect import RedirectCreate, RedirectUpdate


class CRUDRedirect(CRUDBase[Redirect, RedirectCreate, RedirectUpdate]):

    def get_redirect(self, db: Session, alias: str) -> Redirect:
        """
        Return redirect url.
        """
        return db.query(Redirect).filter(Redirect.alias == alias).first()


redirect = CRUDRedirect(Redirect)