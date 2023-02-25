from sqlalchemy import Column, Integer, DateTime, ForeignKey, ForeignKey

from app.models.user import User
from app.db.base_class import Base


class DeviceLogin(Base):
    user_id = Column(ForeignKey(User.id, ondelete="CASCADE"), primary_key=True)
    session_id = Column(Integer, primary_key=True)
    refreshed_at = Column(DateTime, nullable=False)
    expires_at = Column(DateTime, nullable=False)
