# Import all the models, so that Base has them before being
# imported by Alembic
from app.db.base_class import Base
from app.models.tacaua_classification import TacaUAClassification
from app.models.tacaua_game import TacaUAGame
from app.models.tacaua_modality import TacaUAModality
from app.models.tacaua_modality_details import TacaUAModalityDetails
from app.models.tacaua_team import TacaUATeam
from app.models.faina import Faina
from app.models.faina_member import FainaMember
from app.models.faina_roles import FainaRoles
from app.models.team import Team
from app.models.team_colaborators import TeamColaborators
from app.models.team_roles import TeamRoles
from app.models.seniors import Seniors
from app.models.seniors_students import SeniorsStudents
from app.models.users import Users
