from app.crud.base import CRUDBase
from app.models.tacaua_team import TacaUATeam


class CRUDTacaUATeam(CRUDBase[TacaUATeam]):
    ...


tacaua_team = CRUDTacaUATeam(TacaUATeam)
