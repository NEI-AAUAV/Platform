from sqlalchemy import Boolean, Column, Integer, String, Text, Date
from app.db.base_class import Base

class JobOffer(Base):
    id = Column(Integer, primary_key=True, index=True)
    title = Column(String, nullable=False)
    company = Column(String, nullable=False)
    location = Column(String, nullable=False)
    description = Column(Text, nullable=False)
    application_url = Column(String, nullable=True) # can be null if companies prefer emails instead of an url
    expiration_date = Column(Date, nullable=False)
    is_active = Column(Boolean(), default=True)