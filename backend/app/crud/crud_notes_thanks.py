from sqlalchemy.orm import Session

from app.crud.base import CRUDBase
from app.models.notes_thanks import NotesThanks
from app.schemas.notes_thanks import NotesThanksCreate, NotesThanksUpdate, NotesThanksInDB


class CRUDNotesThanks(CRUDBase[NotesThanks, NotesThanksCreate, NotesThanksUpdate]):
    def get_notes_thanks(self, db: Session):
        """
        Return notes thanks.
        """
        return db.query(notes_thanks)


notes_thanks = CRUDNotesThanks(NotesThanks)
