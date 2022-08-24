from pydantic import BaseModel


class NotesBase(BaseModel):
    ...


class NotesCreate(NotesBase):
    ...


class NotesUpdate(NotesBase):
    ...    


class NotesInDB(NotesBase):
    ...
