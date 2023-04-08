from sqlalchemy import Column, Text, Boolean, ForeignKey

from app.models.user import User
from app.db.base_class import Base


class UserEmail(Base):
    email = Column(Text, primary_key=True)
    user_id = Column(
        ForeignKey(User.id, ondelete="CASCADE"), nullable=False, primary_key=True
    )
    active = Column(Boolean, nullable=False, default=False)
