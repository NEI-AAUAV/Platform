from sqlalchemy.orm import Session

from app.schemas.competition import Swiss
from app.models import Group
from app.core.logging import logger


def update_swiss_matches(db: Session, group: Group, metadata: Swiss) -> None:
    logger.debug(metadata.system)
    ...
