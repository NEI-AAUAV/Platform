from fastapi.encoders import jsonable_encoder
from sqlalchemy.orm import Session

from app.crud.base import CRUDBase
from app.schemas.competition import (
    Metadata, SingleElimination, RoundRobin, Swiss, CompetitionCreate)
from app.models.competition import Competition
from app.utils import Ignore
from app.core.logging import logger


class CRUDCompetition(CRUDBase[Competition, Ignore, Ignore]):

    def create_single_elimination(self, competition: Competition, metadata: SingleElimination):
        logger.debug(metadata.system)

        matches_per_round = []
        
        logger.debug(competition.groups)

        # 9: 1 4 2 1
        # 8: 4 2 1
        # 7: 3 2 1
        # 6: 2 2 1
        # 5: 1 2 1
        # 4: 2 1
        # 
        ...

    def create_round_robin(self, metadata: RoundRobin):
        logger.debug(metadata.system)
        ...

    def create_swiss(self, metadata: Swiss):
        logger.debug(metadata.system)
        ...

    def create(self, db: Session, *, obj_in: CompetitionCreate) -> Competition:
        obj_in_data = jsonable_encoder(obj_in)
        db_obj = self.model(**obj_in_data)
        db.add(db_obj)
        db.commit()
        db.refresh(db_obj)

        metadata = Metadata.parse_obj(db_obj.metadata_).__root__

        logger.debug(db_obj.groups)

        if isinstance(metadata, SingleElimination):
            self.create_single_elimination(db_obj, metadata)
        elif isinstance(metadata, RoundRobin):
            self.create_round_robin(db_obj, metadata)
        elif isinstance(metadata, Swiss):
            self.create_swiss(db_obj, metadata)

        return db_obj


competition = CRUDCompetition(Competition)
