from sqlalchemy.orm import Session

from app.crud.base import CRUDBase
from app.models.seniors import Seniors
from app.schemas.seniors import SeniorsCreate, SeniorsUpdate

from typing import List

from datetime import datetime


class CRUDSeniors(CRUDBase[Seniors, SeniorsCreate, SeniorsUpdate]):
    ...

seniors = CRUDSeniors(Seniors)
