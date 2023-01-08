from app.crud.base import CRUDBase
from app.models.notes_subject import NotesSubject
from app.schemas.notes_subject import NotesSubjectCreate, NotesSubjectUpdate


class CRUDNotesSubject(CRUDBase[NotesSubject, NotesSubjectCreate, NotesSubjectUpdate]):
    ...


notes_subject = CRUDNotesSubject(NotesSubject)