from datetime import date
from typing import Optional
from pydantic import BaseModel, Field

class JobOfferBase(BaseModel):
    title: str
    company: str
    location: str
    description: str
    application_url: Optional[str] = Field(None, alias="applicationUrl")
    expiration_date: date = Field(..., alias="expirationDate")
    is_active: bool = Field(True, alias="isActive")

    class Config:
        populate_by_name = True

class JobOfferCreate(JobOfferBase):
    pass

class JobOfferUpdate(JobOfferBase):
    pass

class JobOfferInDBBase(JobOfferBase):
    id: int

    class Config:
        populate_by_name = True
        from_attributes = True

class JobOffer(JobOfferInDBBase):
    pass