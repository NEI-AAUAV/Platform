from typing import List, Tuple, Optional

from sqlalchemy import or_
from sqlalchemy.orm import Session

from app.crud.base import CRUDBase
from app.models.note import Note
from app.models import User
from app.models.subject import Subject
from app.models.teacher import Teacher


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
        curricular_year: Optional[int] = None,
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
        if curricular_year:
            query = query.join(Note.subject)\
                    .filter_by(curricular_year=curricular_year)
        if categories:
            query = query.filter(
                or_(getattr(Note, cat) == 1 for cat in categories))
        total = query.count()
        return total, query.limit(size).offset((page - 1) * size).all()

    def get_note_students(self, db: Session, year: int, subject_code: int, teacher_id: int, curricular_year: int) -> List[User]:
        query = db.query(Note)
        if year:
            query = query.filter(Note.year == year)
        if subject_code:
            query = query.filter(Note.subject_id == subject_code)
        if teacher_id:
            query = query.filter(Note.teacher_id == teacher_id)
        if curricular_year:
            data = query.join(Note.subject)\
                    .filter_by(curricular_year=curricular_year).all()
        else:
            data = query.distinct(Note.author_id).all()

        # data = query.distinct(Note.author_id).all()

        data = [e.author_id for e in data]

        return db.query(User).filter(User.id.in_(data)).all()

    def get_note_teachers(self, db: Session, year: int, subject_code: int, student_id: int, curricular_year: int) -> List[User]:
        query = db.query(Note)
        if year:
            query = query.filter(Note.year == year)
        if subject_code:
            query = query.filter(Note.subject_id == subject_code)
        if student_id:
            query = query.filter(Note.author_id == student_id)
        if curricular_year:
            data = query.join(Note.subject)\
                    .filter_by(curricular_year=curricular_year).all()
        else:
            data = query.distinct(Note.teacher_id).all()

        # data = query.distinct(Note.teacher_id).all()

        data = [e.teacher_id for e in data]
        
        return db.query(Teacher).filter(Teacher.id.in_(data)).all()
    
    def get_note_subjects(self, db: Session, year: int, teacher_id: int, student_id: int, curricular_year: int) -> List[str]:
        query = db.query(Note)
        if year:
            query = query.filter(Note.year == year)
        if teacher_id:
            query = query.filter(Note.teacher_id == teacher_id)
        if student_id:
            query = query.filter(Note.author_id == student_id)
        if curricular_year:
            data = query.join(Note.subject)\
                    .filter_by(curricular_year=curricular_year).all()
        else:
            data = query.distinct(Note.subject_id).all()
        
        data = [e.subject_id for e in data]

        return db.query(Subject).filter(Subject.code.in_(data)).all()
    
    def get_note_years(self, db: Session, subject_code: int, student_id: int, teacher_id: int, curricular_year: int) -> List[int]:
        query = db.query(Note)
        if teacher_id:
            query = query.filter(Note.teacher_id == teacher_id)
        if subject_code:
            query = query.filter(Note.subject_id == subject_code)
        if student_id:
            query = query.filter(Note.author_id == student_id)
        if curricular_year:
            data = query.join(Note.subject)\
                    .filter_by(curricular_year=curricular_year).all()
        else:
            data = query.distinct(Note.year).all()

        # data = query.distinct(Note.year).all()

        data = [e.year for e in data]

        return list(set(data))

    def get_note_curricular_year(self, db: Session, year: int, teacher_id: int, student_id: int, subject_code: int) -> List[str]:
        query = db.query(Note)
        if year:
            query = query.filter(Note.year == year)
        if teacher_id:
            query = query.filter(Note.teacher_id == teacher_id)
        if student_id:
            query = query.filter(Note.author_id == student_id)
        if subject_code:
            query = query.filter(Note.subject_id == subject_code)
        else:
            data = query.distinct(Note.subject_id).all()
        
        data = [e.subject_id for e in data]

        return db.query(Subject).filter(Subject.code.in_(data)).all()
    
note = CRUDNote(Note)
