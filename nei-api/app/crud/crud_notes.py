from typing import List, Tuple, Optional

from sqlalchemy import or_
from sqlalchemy.orm import Session

from app.crud.base import CRUDBase
from app.models.notes import Notes
from app.models.users import Users


class CRUDNotes(CRUDBase[Notes, None, None]):

    def get_notes_categories(self, db: Session) -> List[str]:
        """
        Return every distinct category
        """
        return map(lambda x: x[0], db.query(Notes.category).distinct().all())

    def get_notes_by(
        self, *, db: Session, categories: List[str],
        school_year: Optional[int] = None,
        subject: Optional[int] = None,
        student: Optional[int] = None,
        teacher: Optional[int] = None,
        page: int, size: int
    ) -> Tuple[int, List[Notes]]:
        """
        Return filtered/unfiltered notes
        """
        query = db.query(Notes)
        if school_year:
            query = query.filter(Notes.school_year_id == school_year)
        if subject:
            query = query.filter(Notes.subject_id == subject)
        if student:
            query = query.filter(Notes.author_id == student)
        if teacher:
            query = query.filter(Notes.teacher_id == teacher)
        if categories:
            query = query.filter(
                or_(getattr(Notes, cat) == 1 for cat in categories))
        total = query.count()
        return total, query.limit(size).offset((page - 1) * size).all()

    def get_notes_students(self, db: Session) -> List[Users]:
        return db.query(Users).join(Notes).all()


notes = CRUDNotes(Notes)
