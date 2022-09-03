from re import T
from sqlalchemy.orm import Session

from app.crud.base import CRUDBase
from app.models.team_roles import TeamRoles
from app.schemas.team_roles import TeamRolesCreate, TeamRolesUpdate

from typing import List

from datetime import datetime


class CRUDTeamRoles(CRUDBase[TeamRoles, TeamRolesCreate, TeamRolesUpdate]):
    ...

team_roles = CRUDTeamRoles(TeamRoles)
