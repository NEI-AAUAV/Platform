from app.crud.base import CRUDBase
from app.models.match import Match


class CRUDMatch(CRUDBase[Match, None, None]):
    ...


match = CRUDMatch(Match)
