from typing import List, Tuple, Optional

from sqlalchemy import or_
from sqlalchemy.orm import Session

from app.crud.base import CRUDBase
from app.models.note import Note
from app.models import User


class CRUDNote(CRUDBase[Note, None, None]):

    def get_note_categories(self, db: Session) -> List[str]:
        """
        Return every distinct category
        """
        return map(lambda x: x[0], db.query(Note.category).distinct().all())

    def get_note_by(
        self, *, db: Session, categories: List[str],
        year: Optional[int] = None,
        subject: Optional[int] = None,
        student: Optional[int] = None,
        teacher: Optional[int] = None,
        page: int, size: int
    ) -> Tuple[int, List[Note]]:
        """
        Return filtered/unfiltered note
        """
        query = db.query(Note)
        if year:
            query = query.filter(Note.year == year)
        if subject:
            query = query.filter(Note.subject_id == subject)
        if student:
            query = query.filter(Note.author_id == student)
        if teacher:
            query = query.filter(Note.teacher_id == teacher)
        if categories:
            query = query.filter(
                or_(getattr(Note, cat) == 1 for cat in categories))
        total = query.count()
        return total, query.limit(size).offset((page - 1) * size).all()

    def get_note_students(self, db: Session) -> List[User]:
        return db.query(User).join(Note).all()


note = CRUDNote(Note)
