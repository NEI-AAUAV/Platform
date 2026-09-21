from typing import List

from sqlalchemy.orm import Session

from app.crud.base import CRUDBase
from app.models.team import TeamMember
from app.schemas.team import TeamMemberCreate, TeamMemberUpdate


class CRUDTeamMember(CRUDBase[TeamMember, TeamMemberCreate, TeamMemberUpdate]):
    _foreign_key_checks = {
        "fk_team_member_section_id_team_section": "Team section not found!",
        "fk_team_member_user_id_user": "User not found!",
    }
    _check_violation_msgs = {
        "ck_team_member_name_not_blank": "Name cannot be blank!",
    }



team_member = CRUDTeamMember(TeamMember)
