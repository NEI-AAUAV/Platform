from sqlalchemy.orm import Session

from app.crud.base import CRUDBase
from app.models.notes import Notes
from app.schemas.notes import NotesCreate, NotesUpdate, NotesInDB


class CRUDNotes(CRUDBase[Notes, NotesCreate, NotesUpdate]):
    ...


notes = CRUDNotes(Notes)
