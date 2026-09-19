from sqlalchemy.orm import Session

from app.crud.base import CRUDBase
from app.models.news import News
from app.schemas.news import NewsCreate, NewsUpdate

from typing import List, Tuple


class CRUDNews(CRUDBase[News, NewsCreate, NewsUpdate]):

    def get_news_categories(self, db: Session) -> List[str]:
        """
        Return every distinct category of published news
        """
        return (
            db.query(News.category)
            .filter(News.public.is_(True))
            .distinct()
            .all()
        )

    def get_news_by_categories(self, db: Session, categories: List[str], page: int, size: int) -> Tuple[int, List[News]]:
        """
        Return filtered/unfiltered published news
        """
        # `public` is the CMS publish toggle; unpublished rows are drafts.
        query = (
            db.query(News)
            .filter(News.public.is_(True))
            .order_by(News.created_at.desc())
        )
        if categories:
            query = query.filter(News.category.in_(categories))
        total = query.count()
        return total, query.limit(size).offset((page - 1) * size).all()


news = CRUDNews(News)
