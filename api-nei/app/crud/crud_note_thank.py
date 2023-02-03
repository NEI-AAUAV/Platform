from app.crud.base import CRUDBase
from app.models.note_thank import NoteThank
from app.schemas.note_thank import NoteThankCreate, NoteThankUpdate


class CRUDNoteThank(CRUDBase[NoteThank, NoteThankCreate, NoteThankUpdate]):
    ...


note_thank = CRUDNoteThank(NoteThank)
