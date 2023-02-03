from app.crud.base import CRUDBase
from app.models.note_subject import NoteSubject
from app.schemas.note_subject import NoteSubjectCreate, NoteSubjectUpdate


class CRUDNoteSubject(CRUDBase[NoteSubject, NoteSubjectCreate, NoteSubjectUpdate]):
    ...


note_subject = CRUDNoteSubject(NoteSubject)