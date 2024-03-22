from app.crud.base import CRUDBase
from app.models.faina import FainaRole
from app.schemas.faina import FainaRoleCreate, FainaRoleUpdate


class CRUDFainaRole(CRUDBase[FainaRole, FainaRoleCreate, FainaRoleUpdate]):
    ...


faina_role = CRUDFainaRole(FainaRole)
