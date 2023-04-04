from app.crud.base import CRUDBase
from app.models.user_academic_details import UserAcademicDetails
from app.schemas.user_academic_details import UserAcademicCreate, UserAcademicUpdate


class CRUDUserAcademics(CRUDBase[UserAcademicDetails, UserAcademicCreate, UserAcademicUpdate]):
    ...

useracademics = CRUDSubject(UserAcademicDetails)
