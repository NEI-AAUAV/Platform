from sqlalchemy.orm import Session

from app.models import Group
from app.schemas.competition import RoundRobin
from app.core.logging import logger


def update_round_robin_matches(db: Session, group: Group, metadata: RoundRobin) -> None:
    logger.debug(metadata.system)
    ...
