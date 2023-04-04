from app.crud.base import CRUDBase
from app.models.user_academic_details import UserAcademicDetails
from app.schemas.user_academic_details import UserAcademicDetailsCreate, UserAcademicDetailsUpdate


class CRUDUserAcademics(CRUDBase[UserAcademicDetails, UserAcademicDetailsCreate, UserAcademicDetailsUpdate]):
    def get_by_user_id(self, db, *, user_id: int):
        return db.query(self.model).filter(self.model.user_id == user_id).first()


user_academic = CRUDUserAcademics(UserAcademicDetails)
