from sqlalchemy import Column, String, Integer, SmallInteger

from app.db.base_class import Base


class NotesTypes(Base):
    __tablename__ = "notes_types"

    id = Column(Integer, primary_key=True, autoincrement=True)
    name = Column(String(40))
    download_caption = Column(String(40))
    icon_display = Column(String(40))
    icon_download = Column(String(40))
    external = Column(SmallInteger)
