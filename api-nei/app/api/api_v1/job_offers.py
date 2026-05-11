from typing import Any, List
from fastapi import APIRouter, Depends, HTTPException, Security
from sqlalchemy.orm import Session

from app import crud, schemas
from app.api import deps
from app.api.api_v1 import auth
from app.schemas.user import ScopeEnum

router = APIRouter()

@router.get("/", response_model=List[schemas.JobOffer])
def read_job_offers(
    db: Session = Depends(deps.get_db),
    skip: int = 0,
    limit: int = 100,
    _ = Security(auth.verify_token)
) -> Any:
    """Retrieve job offers."""
    jobs = crud.job_offer.get_multi(db, skip=skip, limit=limit)
    return jobs

@router.get("/{id}", response_model=schemas.JobOffer)
def read_job_offer(
    id: int,
    db: Session = Depends(deps.get_db),
    _ = Security(auth.verify_token)
) -> Any:
    """Get a specific job offer by ID."""
    job = crud.job_offer.get(db=db, id=id)
    if not job:
        raise HTTPException(status_code=404, detail="Job offer not found")
    return job

@router.post("/", response_model=schemas.JobOffer)
def create_job_offer(
    *,
    db: Session = Depends(deps.get_db),
    job_in: schemas.JobOfferCreate,
    _ = Security(auth.verify_token, scopes=[ScopeEnum.MANAGER_JOBS])
) -> Any:
    """Create new job offer (Requires manager-jobs scope)."""
    job = crud.job_offer.create(db=db, obj_in=job_in)
    return job

@router.put("/{id}", response_model=schemas.JobOffer)
def update_job_offer(
    *,
    db: Session = Depends(deps.get_db),
    id: int,
    job_in: schemas.JobOfferUpdate,
    _ = Security(auth.verify_token, scopes=[ScopeEnum.MANAGER_JOBS])
) -> Any:
    """Update a job offer (Requires manager-jobs scope)."""
    job = crud.job_offer.get(db=db, id=id)
    if not job:
        raise HTTPException(status_code=404, detail="Job offer not found")
    job = crud.job_offer.update(db=db, db_obj=job, obj_in=job_in)
    return job