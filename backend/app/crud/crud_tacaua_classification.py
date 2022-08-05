from app.crud.base import CRUDBase
from app.models.tacaua_classification import TacaUAClassification
from app.schemas import TacaUAClassificationCreate, TacaUAClassificationUpdate


class CRUDTacaUAClassification(CRUDBase[TacaUAClassification, TacaUAClassificationCreate, TacaUAClassificationUpdate]):
    ...


tacaua_classification = CRUDTacaUAClassification(TacaUAClassification)
