from sqlalchemy.orm import Session

from app.crud.base import CRUDBase
from app.models.tacaua_game import TacaUAGame
from app.schemas.tacaua_game import TacaUAGameCreate, TacaUAGameUpdate, TacaUAGameInDB

from typing import List

from datetime import datetime


class CRUDTacaUAGame(CRUDBase[TacaUAGame, TacaUAGameCreate, TacaUAGameUpdate]):

    def get_prev_games(self, db: Session, limit: int = 5) -> List[TacaUAGameInDB]:
        """
        Return previous `limit` games according to current datetime.
        """
        return db.query(TacaUAGame).filter(TacaUAGame.date <= datetime.now()) \
            .order_by(TacaUAGame.date.desc()).limit(limit)


tacaua_game = CRUDTacaUAGame(TacaUAGame)
