from app.crud.base import CRUDBase
from app.models.standings import Standings
from app.schemas.standings import StandingsCreate, StandingsUpdate, StandingsInDB, StandingsBase


class CRUDFaina(CRUDBase[Standings, StandingsCreate, StandingsUpdate]):
    ...


standings = CRUDFaina(Standings)
