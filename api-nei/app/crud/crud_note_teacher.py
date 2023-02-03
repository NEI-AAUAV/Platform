from app.crud.base import CRUDBase
from app.models.note_teacher import NoteTeacher
from app.schemas.note_teacher import NoteTeacherCreate, NoteTeacherUpdate


class CRUDNoteTeacher(CRUDBase[NoteTeacher, NoteTeacherCreate, NoteTeacherUpdate]):
    ...


note_teacher = CRUDNoteTeacher(NoteTeacher)
