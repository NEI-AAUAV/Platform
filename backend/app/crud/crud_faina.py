from sqlalchemy.orm import Session

from app.crud.base import CRUDBase
from app.models.faina import Faina
from app.schemas.faina import FainaCreate, FainaUpdate

from typing import List

from datetime import datetime


class CRUDFaina(CRUDBase[Faina, FainaCreate, FainaUpdate]):
    ...

faina = CRUDFaina(Faina)
