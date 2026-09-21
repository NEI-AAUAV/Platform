from datetime import datetime
from sqlalchemy import Column, DateTime, String
from app.db.base_class import Base


class OAuthState(Base):
    __tablename__ = "oauth_state"

    state = Column(String, primary_key=True)
    verifier = Column(String, nullable=True)
    nonce = Column(String, nullable=True)
    redirect = Column(String, nullable=True)
    expires_at = Column(DateTime, nullable=False)
