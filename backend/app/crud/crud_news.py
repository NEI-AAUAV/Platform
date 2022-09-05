from sqlalchemy.orm import Session

from app.crud.base import CRUDBase
from app.models.news import News
from app.schemas.news import NewsCategories, NewsCreate, NewsUpdate, NewsInDB
from app.core.config import Settings
from typing import List


class CRUDNews(CRUDBase[News, NewsCreate, NewsUpdate]):

    def get_news_categories(self, db: Session) -> list[str]:
        """
        Return every distinct category
        """
        return db.query(News.category).distinct().all()

    def get_news_by_id(self, db: Session, id: int) -> NewsInDB:
        """
        Return individual new info
        """
        return db.query(News).filter(News.id == id).first()

    def get_news_by_categories(self, db: Session, categories: list[str], page: int, size: int) -> List[NewsInDB]:
        """
        Return filtered/unfiltered news
        """
        if categories:
            return db.query(News).\
                filter(News.category.in_(categories)).\
                limit(size).offset((page - 1) * size).all()
        else:
            return db.query(News).\
                limit(size).offset((page - 1) * size).all()


news = CRUDNews(News)
