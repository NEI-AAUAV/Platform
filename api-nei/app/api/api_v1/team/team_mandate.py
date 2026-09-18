from fastapi import APIRouter, Depends, HTTPException

from sqlalchemy.orm import Session

from app import crud
from app.api import deps
from app.schemas import TeamMandates, TeamMandateTree

router = APIRouter()


@router.get("/", status_code=200, response_model=TeamMandates)
def get_team_mandates(db: Session = Depends(deps.get_db), _=Depends(deps.long_cache)):
    """Return every mandate that has a team registered."""
    data = crud.team_mandate.get_mandates(db=db)
    return {"data": data}


@router.get("/{mandate:path}", status_code=200, response_model=TeamMandateTree)
def get_team_mandate_tree(
    mandate: str, db: Session = Depends(deps.get_db), _=Depends(deps.long_cache)
):
    """Return a mandate's full team, nested by category and section."""
    tree = crud.team_mandate.get_tree(db=db, mandate=mandate)
    if tree is None:
        raise HTTPException(status_code=404, detail="Mandate not found")
    return tree
