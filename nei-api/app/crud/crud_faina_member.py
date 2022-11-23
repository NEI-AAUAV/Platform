from sqlalchemy.orm import Session
from sqlalchemy import and_

from app.crud.base import CRUDBase
from app.models.faina_member import FainaMember
from app.schemas.faina_member import FainaMemberCreate, FainaMemberUpdate, FainaMemberInDB

from typing import List

from datetime import datetime


class CRUDFainaMember(CRUDBase[FainaMember, FainaMemberCreate, FainaMemberUpdate]):
    
    def get_faina_member(self, db: Session, mandato_id: int, member_id: int, role_id: int) -> FainaMemberInDB:
        """
        Return redirect url.
        """
        return db.query(FainaMember).filter(and_(FainaMember.mandato_id==mandato_id, FainaMember.member_id==member_id, FainaMember.role_id==role_id)).first()

faina_member = CRUDFainaMember(FainaMember)
