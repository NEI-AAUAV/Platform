from .tacaua_classification import TacaUAClassificationCreate, TacaUAClassificationUpdate, TacaUAClassificationInDB
from .tacaua_game import TacaUAGameCreate, TacaUAGameUpdate, TacaUAGameInDB
from .tacaua_modality import TacaUAModalityCreate, TacaUAModalityUpdate, TacaUAModalityInDB
from .tacaua_team import TacaUATeamCreate, TacaUATeamUpdate, TacaUATeamInDB
from .notes import NotesCreate, NotesUpdate, NotesInDB
from .faina import FainaBase, FainaCreate, FainaInDB, FainaUpdate
from .faina_roles import FainaRolesBase, FainaRolesCreate, FainaRolesInDB, FainaRolesUpdate
from .faina_member import FainaMemberBase, FainaMemberInDB, FainaMemberUpdate, FainaMemberCreate
from .team import TeamBase, TeamCreate, TeamInDB, TeamUpdate
from .team_colaborators import TeamColaboratorsBase, TeamColaboratorsCreate, TeamColaboratorsInDB, TeamColaboratorsUpdate
from .team_roles import TeamRolesBase, TeamRolesCreate, TeamRolesInDB, TeamRolesUpdate
from .seniors import SeniorsBase, SeniorsCreate, SeniorsInDB, SeniorsUpdate
from .seniors_students import SeniorsStudentsBase, SeniorsStudentsCreate, SeniorsStudentsInDB, SeniorsStudentsUpdate
from .notes_thanks import NotesThanksCreate, NotesThanksUpdate, NotesThanksInDB
from .notes_schoolyear import NotesSchoolyearCreate, NotesSchoolyearUpdate, NotesSchoolyearInDB
from .notes_subject import NotesSubjectCreate, NotesSubjectUpdate, NotesSubjectInDB
from .notes_types import NotesTypesCreate, NotesTypesUpdate, NotesTypesInDB
from .notes_teachers import NotesTeachersCreate, NotesTeachersUpdate, NotesTeachersInDB
from .users import UsersCreate, UsersUpdate, UsersInDB
from .video import VideoInDB, VideoCreate, VideoUpdate
from .video_tag import VideoTagInDB
from .redirect import RedirectInDB, RedirectCreate, RedirectUpdate
from .news import NewsInDB, NewsCategories, NewsCreate, NewsUpdate
