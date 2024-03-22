from app.crud.base import CRUDBase
from app.models.subject import Subject
from app.schemas.subject import SubjectCreate, SubjectUpdate


class CRUDSubject(CRUDBase[Subject, SubjectCreate, SubjectUpdate]):
    def get_by_code(self, db_session, *, code: int) -> Subject:
        return db_session.query(Subject).filter(Subject.code == code).first()


subject = CRUDSubject(Subject)
