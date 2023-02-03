from app.crud.base import CRUDBase
from app.models.note_type import NoteType
from app.schemas.note_type import NoteTypeCreate, NoteTypeUpdate


class CRUDNoteType(CRUDBase[NoteType, NoteTypeCreate, NoteTypeUpdate]):
    ...


note_type = CRUDNoteType(NoteType)
