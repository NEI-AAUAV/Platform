# Import all the models, so that Base has them before being
# imported by Alembic
from app.db.base_class import Base
from app.models.tacaua_classification import TacaUAClassification
from app.models.tacaua_game import TacaUAGame
from app.models.tacaua_modality import TacaUAModality
from app.models.tacaua_modality_details import TacaUAModalityDetails
from app.models.tacaua_team import TacaUATeam
from app.models.history import History
from app.models.rgm import Rgm
from app.models.partners import Partners
from app.models.merchandisings import Merchandisings

