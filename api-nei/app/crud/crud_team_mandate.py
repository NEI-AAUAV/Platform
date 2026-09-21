from typing import List

from pydantic import BaseModel
from sqlalchemy import select
from sqlalchemy.orm import Session, selectinload

from app.crud.base import CRUDBase
from app.models.team import TeamMandate, TeamSection, TeamMember


# Mandates are created in the CMS; only the read helpers below are used.
class CRUDTeamMandate(CRUDBase[TeamMandate, BaseModel, BaseModel]):
    def get_mandates(self, db: Session) -> List[str]:
        """Return every distinct mandate, most recent first."""
        stmt = select(TeamMandate.mandate).order_by(TeamMandate.mandate.desc())
        return db.scalars(stmt).all()

    def get_tree(self, db: Session, mandate: str) -> TeamMandate:
        """Return a mandate with sections/members eagerly loaded."""
        stmt = (
            select(TeamMandate)
            .where(TeamMandate.mandate == mandate)
            .options(
                selectinload(TeamMandate.sections)
                .selectinload(TeamSection.members)
                .selectinload(TeamMember.user)
            )
        )
        return db.scalars(stmt).first()


team_mandate = CRUDTeamMandate(TeamMandate)
