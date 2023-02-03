from app.crud.base import CRUDBase
from app.models.note_schoolyear import NoteSchoolYear
from app.schemas.note_schoolyear import NoteSchoolyearCreate, NoteSchoolyearUpdate


class CRUDNoteSchoolyear(CRUDBase[NoteSchoolYear, NoteSchoolyearCreate, NoteSchoolyearUpdate]):
    ...


note_schoolyear = CRUDNoteSchoolyear(NoteSchoolYear)
