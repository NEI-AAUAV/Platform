from sqlalchemy.orm import Session

from app.crud.base import CRUDBase
from app.models.news import News
from app.schemas.news import NewsCategories, NewsCreate, NewsUpdate, NewsInDB
from app.core.config import Settings
from typing import List

from datetime import datetime

class CRUDNews(CRUDBase[News, NewsCreate, NewsUpdate]):

    def get_news_categories(self, db: Session, limit: int = 5) -> NewsCategories:
        """
        Return every distinct category
        """
        return {"data": db.query(News.category).distinct()}

    def get_news_by_id(self, db: Session, id: int) -> NewsInDB:
        """
        Return individual new info
        """
        return db.query(News).filter(News.id == id).first()

    def get_news_by_categories(self, db: Session, categories: list[str], pagenumber: int) -> List[NewsInDB]:
        """
        Return filtered/unfileted news
        """
        if categories == None:
            return db.query(News).\
            limit(Settings.PAGESIZE).offset((pagenumber - 1) * Settings.PAGESIZE).all()
        else:
            return db.query(News).\
            filter(bool(set(News.category) & set(categories))).\
            limit(Settings.PAGESIZE).offset((pagenumber - 1) * Settings.PAGESIZE).all()



news = CRUDNews(News)
