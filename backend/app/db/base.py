# Import all the models, so that Base has them before being
# imported by Alembic
from app.db.base_class import Base
from app.models.tacaua_classification import TacaUAClassification
from app.models.tacaua_game import TacaUAGame
from app.models.tacaua_modality import TacaUAModality
from app.models.tacaua_modality_details import TacaUAModalityDetails
from app.models.tacaua_team import TacaUATeam
from app.models.notes import Notes
from app.models.notes_schoolyear import NotesSchoolYear
from app.models.notes_subject import NotesSubject
from app.models.notes_teachers import NotesTeachers
from app.models.notes_thanks import NotesThanks
from app.models.notes_types import NotesTypes
from app.models.users import Users