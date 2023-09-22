from app.crud.base import CRUDBase
from app.models.standings import Standings
from app.schemas.standings import StandingsCreate, StandingsUpdate, StandingsInDB, StandingsBase
from sqlalchemy.orm import Session
from typing import Any, Optional, List
from app.exception import NotFoundException


class CRUDStandings(CRUDBase[Standings, StandingsCreate, StandingsUpdate]):

    def get_table(self, db: Session, *, group_id: Any) -> Optional[List[Standings]]:
        obj = (
            db.query(Standings)
            .filter(Standings.group_id == group_id)
        )
        if not obj:
            raise NotFoundException(
                detail=f"{self.model.__name__} Not Found")
        return obj


standings = CRUDStandings(Standings)
