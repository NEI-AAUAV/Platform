from sqlalchemy.orm import Session

from app.crud.base import CRUDBase
from app.models.notes_teachers import NotesTeachers
from app.schemas.notes_teachers import NotesTeachersCreate, NotesTeachersUpdate, NotesTeachersInDB


class CRUDNotesTeachers(CRUDBase[NotesTeachers, NotesTeachersCreate, NotesTeachersUpdate]):
    ...


notes_teachers = CRUDNotesTeachers(NotesTeachers)
