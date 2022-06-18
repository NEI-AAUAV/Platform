from app.crud.base import CRUDBase
from app.models.tacaua_game import TacaUAGame
from app.schemas.tacaua_game import TacaUAGameCreate, TacaUAGameUpdate


class CRUDTacaUAGame(CRUDBase[TacaUAGame, TacaUAGameCreate, TacaUAGameUpdate]):
    ...


tacaua_game = CRUDTacaUAGame(TacaUAGame)
