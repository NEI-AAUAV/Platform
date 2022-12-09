from .faina import FainaBase, FainaCreate, FainaInDB, FainaUpdate
from .faina_roles import FainaRolesBase, FainaRolesCreate, FainaRolesInDB, FainaRolesUpdate
from .faina_member import FainaMemberBase, FainaMemberInDB, FainaMemberUpdate, FainaMemberCreate
from .team import TeamBase, TeamCreate, TeamInDB, TeamUpdate
from .team_colaborators import TeamColaboratorsBase, TeamColaboratorsCreate, TeamColaboratorsInDB, TeamColaboratorsUpdate
from .team_roles import TeamRolesBase, TeamRolesCreate, TeamRolesInDB, TeamRolesUpdate
from .seniors import SeniorsBase, SeniorsCreate, SeniorsInDB, SeniorsUpdate
from .seniors_students import SeniorsStudentsBase, SeniorsStudentsCreate, SeniorsStudentsInDB, SeniorsStudentsUpdate
from .notes import NotesInDB
from .notes_thanks import NotesThanksInDB
from .notes_schoolyear import NotesSchoolyearInDB
from .notes_subject import NotesSubjectInDB
from .notes_types import NotesTypesInDB
from .notes_teachers import NotesTeachersInDB
from .users import UsersCreate, UsersUpdate, UsersInDB
from .video import VideoInDB, VideoCreate, VideoUpdate
from .video_tag import VideoTagInDB
from .redirect import RedirectInDB, RedirectCreate, RedirectUpdate
from .news import NewsInDB, NewsCategories, NewsCreate, NewsUpdate
