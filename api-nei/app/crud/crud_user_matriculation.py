from app.crud.base import CRUDBase
from app.models.user import UserMatriculation
from app.schemas.user import UserMatriculationCreate, UserMatriculationUpdate


class CRUDUserMatriculation(CRUDBase[UserMatriculation, UserMatriculationCreate, UserMatriculationUpdate]):
    def get_by_user_id(self, db, *, user_id: int):
        return db.query(self.model).filter(self.model.user_id == user_id).first()


user_matriculation = CRUDUserMatriculation(UserMatriculation)
