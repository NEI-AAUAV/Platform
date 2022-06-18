from app.crud.base import CRUDBase
from app.models.tacaua_classification import TacaUAClassification


class CRUDTacaUAClassification(CRUDBase[TacaUAClassification]):
    ...


tacaua_team = CRUDTacaUAClassification(TacaUAClassification)
