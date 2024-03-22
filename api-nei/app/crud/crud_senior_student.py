from app.crud.base import CRUDBase
from app.models.senior.senior_student import SeniorStudent
from app.schemas.senior.senior_student import SeniorStudentCreate, SeniorStudentUpdate


class CRUDSeniorStudent(
    CRUDBase[SeniorStudent, SeniorStudentCreate, SeniorStudentUpdate]
):
    _foreign_key_checks = {"fk_senior_student_senior_id_senior": "Senior not found"}
    ...


senior_student = CRUDSeniorStudent(SeniorStudent)
