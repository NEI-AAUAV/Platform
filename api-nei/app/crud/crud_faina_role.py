from app.crud.base import CRUDBase
from app.models.faina_role import FainaRole
from app.schemas.faina_role import FainaRoleCreate, FainaRoleUpdate


class CRUDFainaRole(CRUDBase[FainaRole, FainaRoleCreate, FainaRoleUpdate]):
    ...


faina_role = CRUDFainaRole(FainaRole)
