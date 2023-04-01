from app.crud.base import CRUDBase
from app.models.course import Course
from app.schemas.course import CourseCreate, CourseUpdate


class CRUDCourse(CRUDBase[Course, CourseCreate, CourseUpdate]):
    def get_by_code(self, db_session, *, code: int) -> Course:
        return db_session.query(Course).filter(Course.code == code).first()


course = CRUDCourse(Course)
