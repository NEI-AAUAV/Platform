from sqlalchemy.orm import Session
from sqlalchemy.exc import IntegrityError
from fastapi.encoders import jsonable_encoder

from app.crud.base import CRUDBase
from app.models.job_offer import JobOffer
from app.schemas.job_offer import JobOfferCreate, JobOfferUpdate

class CRUDJobOffer(CRUDBase[JobOffer, JobOfferCreate, JobOfferUpdate]):
    
    def create(self, db: Session, *, obj_in: JobOfferCreate) -> JobOffer:
        # by_alias=False forces it to output 'application_url' instead of 'applicationUrl'
        obj_in_data = jsonable_encoder(obj_in, by_alias=False)
        db_obj = self.model(**obj_in_data)
        
        try:
            db.add(db_obj)
            db.commit()
            db.refresh(db_obj)
            return db_obj
        except IntegrityError as e:
            self._integrity_error_handler(e)
            raise e

job_offer = CRUDJobOffer(JobOffer)