from app.crud.base import CRUDBase
from app.models.tacaua_team import TacaUATeam
from app.schemas.tacaua_team import TacaUATeamCreate, TacaUATeamUpdate


class CRUDTacaUATeam(CRUDBase[TacaUATeam, TacaUATeamCreate, TacaUATeamUpdate]):
    ...


tacaua_team = CRUDTacaUATeam(TacaUATeam)
