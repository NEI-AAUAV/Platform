from sqlalchemy import Column, String, Integer, DateTime, ForeignKey, Enum
from sqlalchemy.orm import relationship

from app.core.config import settings
from app.db.base_class import Base
from app.schemas.news import StatusEnum, CategoryEnum


class News(Base):
    __tablename__ = "news"

    id = Column(Integer, primary_key=True, autoincrement=True)
    header = Column(String(255))
    status = Column(Enum(StatusEnum, name="status_enum", create_type=False))
    title = Column(String(255))
    category = Column(Enum(CategoryEnum, name="category_enum", create_type=False))
    content = Column(String(20000))
    published_by = Column(Integer, ForeignKey(settings.SCHEMA_NAME + ".users.id", name="fk_publisher_id"), index=True)
    created_at = Column(DateTime)
    last_change_at = Column(DateTime)
    changed_by = Column(Integer, ForeignKey(settings.SCHEMA_NAME + ".users.id", name="fk_editor_id"), index=True)
    author_id = Column(Integer, ForeignKey(settings.SCHEMA_NAME + ".users.id", name="fk_author_id"), index=True)
    publisher = relationship("Users", foreign_keys=[published_by])
    editor = relationship("Users", foreign_keys=[changed_by])
    author = relationship("Users", foreign_keys=[author_id])
