from sqlalchemy import Column, String, Integer, DateTime, ForeignKey, Enum
from sqlalchemy.orm import relationship

from app.core.config import settings
from app.db.base_class import Base
from app.schemas.news import StatusEnum


class News(Base):
    __tablename__ = "news"

    id = Column(Integer, primary_key=True, autoincrement=True)
    header: Column(String(255))
    status: Column(Enum(StatusEnum, name="type_enum", create_type=False))
    title: Column(String(255))
    category: Column(String(255))
    content: Column(String(20000))
    publish_by: Column(Integer, ForeignKey(settings.SCHEMA_NAME + ".users.id", name="fk_publisher_id"), index=True)
    created_at: Column(DateTime)
    last_change_at: Column(DateTime)
    changed_by: Column(Integer, ForeignKey(settings.SCHEMA_NAME + ".users.id", name="fk_editor_id"), index=True)
    author_id: Column(Integer, ForeignKey(settings.SCHEMA_NAME + ".users.id", name="fk_author_id"), index=True)

    publisher: relationship("users", foreign_keys=[id])
    editor: relationship("users", foreign_keys=[id])
    author: relationship("users", foreign_keys=[id])