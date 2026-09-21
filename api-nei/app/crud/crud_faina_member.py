from sqlalchemy.orm import Session
from sqlalchemy import and_

from app.crud.base import CRUDBase
from app.models.faina import FainaMember
from app.schemas.faina import FainaMemberCreate, FainaMemberUpdate


class CRUDFainaMember(CRUDBase[FainaMember, FainaMemberCreate, FainaMemberUpdate]):
    _foreign_key_checks = {
        "fk_faina_member_faina_id_faina": "Faina Not Found",
        "fk_faina_member_member_id_user": "User Not Found",
        "fk_faina_member_role_id_faina_role": "Faina Role Not Found",
    }
    _check_violation_msgs = {
        "ck_faina_member_identity_required": (
            "A member needs either a linked user or a name."
        ),
    }

    def get_faina_member(
        self, db: Session, faina_id: int, member_id: int, role_id: int
    ) -> FainaMember:
        """
        Return redirect url.
        """
        return (
            db.query(FainaMember)
            .filter(
                and_(
                    FainaMember.faina_id == faina_id,
                    FainaMember.member_id == member_id,
                    FainaMember.role_id == role_id,
                )
            )
            .first()
        )


faina_member = CRUDFainaMember(FainaMember)
