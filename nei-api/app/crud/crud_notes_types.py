from app.crud.base import CRUDBase
from app.models.notes_types import NotesTypes
from app.schemas.notes_types import NotesTypesCreate, NotesTypesUpdate


class CRUDNotesTypes(CRUDBase[NotesTypes, NotesTypesCreate, NotesTypesUpdate]):
    ...


notes_types = CRUDNotesTypes(NotesTypes)
