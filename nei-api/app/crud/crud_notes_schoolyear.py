from app.crud.base import CRUDBase
from app.models.notes_schoolyear import NotesSchoolYear
from app.schemas.notes_schoolyear import NotesSchoolyearCreate, NotesSchoolyearUpdate


class CRUDNotesSchoolyear(CRUDBase[NotesSchoolYear, NotesSchoolyearCreate, NotesSchoolyearUpdate]):
    ...


notes_schoolyear = CRUDNotesSchoolyear(NotesSchoolYear)
