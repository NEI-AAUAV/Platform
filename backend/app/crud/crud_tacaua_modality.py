from app.crud.base import CRUDBase
from app.models.tacaua_modality import TacaUAModality
from app.schemas.tacaua_modality import TacaUAModalityCreate, TacaUAModalityUpdate


class CRUDTacaUAModality(CRUDBase[TacaUAModality, TacaUAModalityCreate, TacaUAModalityUpdate]):
    ...


tacaua_modality = CRUDTacaUAModality(TacaUAModality)
