from typing import List, Tuple

from sqlalchemy import or_
from sqlalchemy.orm import Session

from app.crud.base import CRUDBase
from app.models.notes import Notes


class CRUDNotes(CRUDBase[Notes, None, None]):

    def get_notes_categories(self, db: Session) -> List[str]:
        """
        Return every distinct category
        """
        return map(lambda x: x[0], db.query(Notes.category).distinct().all())

    def get_notes_by_categories(self, db: Session, categories: List[str], page: int, size: int) -> Tuple[int, List[Notes]]:
        """
        Return filtered/unfiltered notes
        """
        query = db.query(Notes)
        if categories:
            query = query.filter(or_(getattr(Notes, cat) == 1 for cat in categories))
        total = query.count()
        return total, query.limit(size).offset((page - 1) * size).all()


notes = CRUDNotes(Notes)
