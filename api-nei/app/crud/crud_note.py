from typing import List, Tuple, Optional

from sqlalchemy import or_
from sqlalchemy.orm import Query, Session, joinedload

from app.crud.base import ReadOnlyCRUDBase
from app.models.note import Note
from app.models import User
from app.models.subject import Subject
from app.models.teacher import Teacher


class CRUDNote(ReadOnlyCRUDBase[Note]):
    @staticmethod
    def _filtered(
        db: Session,
        *,
        year: Optional[int] = None,
        subject: Optional[int] = None,
        student: Optional[int] = None,
        teacher: Optional[int] = None,
        curricular_year: Optional[int] = None,
    ) -> Query:
        """Notes matching every given (truthy) filter."""
        query = db.query(Note)
        if year:
            query = query.filter(Note.year == year)
        if subject:
            query = query.filter(Note.subject_id == subject)
        if student:
            query = query.filter(Note.author_id == student)
        if teacher:
            query = query.filter(Note.teacher_id == teacher)
        if curricular_year:
            query = query.join(Note.subject).filter_by(
                curricular_year=curricular_year
            )
        return query

    def get_note_by(
        self, *, db: Session, categories: List[str],
        year: Optional[int] = None,
        subject: Optional[int] = None,
        student: Optional[int] = None,
        teacher: Optional[int] = None,
        curricular_year: Optional[int] = None,
        page: int, size: int
    ) -> Tuple[int, List[Note]]:
        """
        Return filtered/unfiltered note
        """
        query = self._filtered(
            db, year=year, subject=subject, student=student,
            teacher=teacher, curricular_year=curricular_year,
        )
        if categories:
            query = query.filter(
                or_(*(getattr(Note, cat) == 1 for cat in categories)))
        total = query.count()
        page_query = query.options(
            joinedload(Note.author),
            joinedload(Note.note_author),
            joinedload(Note.subject),
            joinedload(Note.teacher),
        )
        return total, page_query.limit(size).offset((page - 1) * size).all()

    def get_note_students(self, db: Session, year: Optional[int], subject_code: Optional[int], teacher_id: Optional[int], curricular_year: Optional[int]) -> List[User]:
        notes = self._filtered(
            db, year=year, subject=subject_code, teacher=teacher_id,
            curricular_year=curricular_year,
        ).all()
        ids = set(e.author_id for e in notes)
        return db.query(User).filter(User.id.in_(ids)).all()

    def get_note_teachers(self, db: Session, year: Optional[int], subject_code: Optional[int], student_id: Optional[int], curricular_year: Optional[int]) -> List[Teacher]:
        notes = self._filtered(
            db, year=year, subject=subject_code, student=student_id,
            curricular_year=curricular_year,
        ).all()
        ids = set(e.teacher_id for e in notes)
        return db.query(Teacher).filter(Teacher.id.in_(ids)).all()

    def get_note_subjects(self, db: Session, year: Optional[int], teacher_id: Optional[int], student_id: Optional[int], curricular_year: Optional[int]) -> List[Subject]:
        notes = self._filtered(
            db, year=year, teacher=teacher_id, student=student_id,
            curricular_year=curricular_year,
        ).all()
        codes = set(e.subject_id for e in notes)
        return db.query(Subject).filter(Subject.code.in_(codes)).all()

    def get_note_years(self, db: Session, subject_code: Optional[int], student_id: Optional[int], teacher_id: Optional[int], curricular_year: Optional[int]) -> List[int]:
        notes = self._filtered(
            db, subject=subject_code, student=student_id, teacher=teacher_id,
            curricular_year=curricular_year,
        ).all()
        years = set(e.year for e in notes if e.year)
        years.discard(None)
        return list(years)

    def get_note_curricular_year(self, db: Session, year: Optional[int], teacher_id: Optional[int], student_id: Optional[int], subject_code: Optional[int]) -> List[str]:
        notes = (
            self._filtered(
                db, year=year, teacher=teacher_id, student=student_id,
                subject=subject_code,
            )
            .options(joinedload(Note.subject))
            .all()
        )
        years = set(e.subject.curricular_year for e in notes)
        years.discard(None)
        return list(years)


note = CRUDNote(Note)
