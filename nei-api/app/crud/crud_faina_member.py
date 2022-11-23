from sqlalchemy.orm import Session
from sqlalchemy import and_

from app.crud.base import CRUDBase
from app.models.faina_member import FainaMember
from app.schemas.faina_member import FainaMemberCreate, FainaMemberUpdate


class CRUDFainaMember(CRUDBase[FainaMember, FainaMemberCreate, FainaMemberUpdate]):
    
    def get_faina_member(self, db: Session, faina_id: int, member_id: int, role_id: int) -> FainaMember:
        """
        Return redirect url.
        """
        return db.query(FainaMember).filter(and_(FainaMember.faina_id==faina_id, FainaMember.member_id==member_id, FainaMember.role_id==role_id)).first()


faina_member = CRUDFainaMember(FainaMember)
