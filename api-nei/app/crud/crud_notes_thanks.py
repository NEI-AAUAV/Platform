from app.crud.base import CRUDBase
from app.models.notes_thanks import NotesThanks
from app.schemas.notes_thanks import NotesThanksCreate, NotesThanksUpdate


class CRUDNotesThanks(CRUDBase[NotesThanks, NotesThanksCreate, NotesThanksUpdate]):
    ...


notes_thanks = CRUDNotesThanks(NotesThanks)
