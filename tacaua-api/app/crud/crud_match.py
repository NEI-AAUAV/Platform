from app.crud.base import CRUDBase
from app.models.match import Match


class CRUDMatch(CRUDBase[Match, None, None]):
    
    def update(self) -> Match:
        # swap matches, como dar handle a updates? como mandar 2 matches?
        ...


match = CRUDMatch(Match)
