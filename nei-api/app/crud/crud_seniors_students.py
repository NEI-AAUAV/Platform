from app.crud.base import CRUDBase
from app.models.seniors_students import SeniorsStudents
from app.schemas.seniors_students import SeniorsStudentsCreate, SeniorsStudentsUpdate


class CRUDSeniorsStudents(CRUDBase[SeniorsStudents, SeniorsStudentsCreate, SeniorsStudentsUpdate]):
   ...


seniors_students = CRUDSeniorsStudents(SeniorsStudents)
