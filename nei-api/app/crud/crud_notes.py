from sqlalchemy.orm import Session

from app.crud.base import CRUDBase
from app.models.notes import Notes
from app.schemas.notes import NotesInDB
from typing import List


class CRUDNotes(CRUDBase[Notes, None, None]):
    
    def get_notes_categories(self, db: Session) -> List[str]:
        """
        Return every distinct category
        """
        return map(lambda x: x[0], db.query(Notes.category).distinct().all())

    def get_notes_by_id(self, db: Session, id: int) -> NotesInDB:
        """
        Return note by id
        """
        return db.query(Notes).filter(Notes.id == id).first()
    
    def get_notes_by_categories(self, db: Session, categories: List[str], page: int, size: int) -> List[NotesInDB]:
        """
        Return filtered/unfiltered notes
        """
        query = db.query(Notes)
        for cat in categories:
            query = query.filter(getattr(Notes, cat) == 1)
        return query.limit(size).offset((page - 1) * size).all()


notes = CRUDNotes(Notes)
