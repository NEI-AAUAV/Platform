from sqlalchemy.orm import Session

from app.crud.base import CRUDBase
from app.models.notes_schoolyear import NotesSchoolYear
from app.schemas.notes_schoolyear import NotesSchoolyearCreate, NotesSchoolyearUpdate, NotesSchoolyearInDB


class CRUDNotesSchoolyear(CRUDBase[NotesSchoolYear, NotesSchoolyearCreate, NotesSchoolyearUpdate]):
    ...


notes_schoolyear = CRUDNotesSchoolyear(NotesSchoolYear)
