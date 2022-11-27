from app.crud.base import CRUDBase
from app.models.checkpoint import CheckPoint
from app.schemas.checkpoint import CheckPointBase

class CRUDCheckpoint(CRUDBase[CheckPoint,CheckPointBase]):
    ...

checkPoint = CRUDCheckpoint(CheckPoint)
