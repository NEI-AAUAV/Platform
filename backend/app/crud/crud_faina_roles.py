from sqlalchemy.orm import Session

from app.crud.base import CRUDBase
from app.models.faina_roles import FainaRoles
from app.schemas.faina_roles import FainaRolesCreate, FainaRolesUpdate


class CRUDFainaRoles(CRUDBase[FainaRoles, FainaRolesCreate, FainaRolesUpdate]):
    ...

faina_roles = CRUDFainaRoles(FainaRoles)
