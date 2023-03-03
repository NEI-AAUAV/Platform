from .faina import FainaBase, FainaCreate, FainaInDB, FainaUpdate
from .faina_role import FainaRoleBase, FainaRoleCreate, FainaRoleInDB, FainaRoleUpdate
from .faina_member import FainaMemberBase, FainaMemberInDB, FainaMemberUpdate, FainaMemberCreate
from .team_member import TeamMemberBase, TeamMemberCreate, TeamMemberInDB, TeamMemberUpdate
from .team_colaborator import TeamColaboratorBase, TeamColaboratorCreate, TeamColaboratorInDB, TeamColaboratorUpdate
from .team_role import TeamRoleBase, TeamRoleCreate, TeamRoleInDB, TeamRoleUpdate
from .senior import SeniorBase, SeniorCreate, SeniorInDB, SeniorUpdate
from .senior_student import SeniorStudentBase, SeniorStudentCreate, SeniorStudentInDB, SeniorStudentUpdate
from .note import NoteInDB
from .subject import SubjectInDB
from .teacher import TeacherInDB
from .user import UserCreate, UserUpdate, UserInDB
from .video import VideoInDB, VideoCreate, VideoUpdate
from .video_tag import VideoTagInDB
from .redirect import RedirectInDB, RedirectCreate, RedirectUpdate
from .news import NewsInDB, NewsCategories, NewsCreate, NewsUpdate
