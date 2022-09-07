from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from typing import Any, List

from app import crud
from app.api import deps
from app.schemas import TacaUAGameCreate, TacaUAGameUpdate, TacaUAGameInDB

from fastapi.encoders import jsonable_encoder

router = APIRouter()


@router.get("/", status_code=200, response_model=List[TacaUAGameInDB])
def get_prev_tacaua_games(
    *, db: Session = Depends(deps.get_db),
) -> Any:
    """
    Return the previous 5 games.
    """
    return crud.tacaua_game.get_prev_games(db=db, limit=5)


@router.post("/", status_code=201, response_model=TacaUAGameInDB)
def create_tacaua_game(
    *, tacaua_game_in: TacaUAGameCreate, db: Session = Depends(deps.get_db)
) -> dict:
    """
    Create a new tacaUA game in the database.
    """
    # tacaua_game_in = jsonable_encoder(tacaua_game_in)
    return crud.tacaua_game.create(db=db, obj_in=tacaua_game_in)


@router.put("/{id}", status_code=200, response_model=TacaUAGameInDB)
def update_tacaua_game(
    *, id: int, tacaua_game_in: TacaUAGameUpdate, db: Session = Depends(deps.get_db)
) -> dict:
    """
    Update a tacaUA game in the database.
    """
    tacaua_game = crud.tacaua_game.get(db=db, id=id)
    if not tacaua_game:
        raise HTTPException(status_code=404, detail="Game Not Found")
    return crud.tacaua_game.update(db=db, db_obj=tacaua_game, obj_in=tacaua_game_in)
