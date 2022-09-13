from sqlalchemy.orm import Session, noload
from typing import List

from app.crud.base import CRUDBase
from app.models.competition import Competition
from app.utils import Ignore


class CRUDCompetition(CRUDBase[Competition, Ignore, Ignore]):
    ...


competition = CRUDCompetition(Competition)
