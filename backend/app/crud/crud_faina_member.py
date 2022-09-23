from sqlalchemy.orm import Session

from app.crud.base import CRUDBase
from app.models.faina_member import FainaMember
from app.schemas.faina_member import FainaMemberCreate, FainaMemberUpdate

from typing import List

from datetime import datetime


class CRUDFainaMember(CRUDBase[FainaMember, FainaMemberCreate, FainaMemberUpdate]):
    ...

faina_member = CRUDFainaMember(FainaMember)
