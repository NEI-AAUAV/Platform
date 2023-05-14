from fastapi import APIRouter, Security, HTTPException
from pydantic import BaseModel
from pymongo import ReturnDocument
from pymongo.errors import OperationFailure
from typing import List
from app.core.db.types import DBType

from app.models.table import Companion, Table, TablePerson, DishType
from app.api.auth import AuthData, api_nei_auth
from app.core.db import DatabaseDep
from app.core.logging import logger
import app.queries.table as table_queries

from ._utils import sanitize_table, fetch_table, NotFoundReCheck

router = APIRouter()


async def person_in_table(uid: int, db: DBType) -> bool:
    res = await Table.get_collection(db).find_one({"persons.id": uid})
    return res is not None


class TableReservationForm(BaseModel):
    dish: DishType
    allergies: str = ""
    companions: List[Companion]


@router.post(
    "/{table_id}/reserve",
    responses={
        404: {"description": "Table not found"},
        409: {"description": "Table already full or person already belongs to a table"},
    },
)
async def reserve_table(
    table_id: int,
    form_data: TableReservationForm,
    *,
    db: DatabaseDep,
    auth_data: AuthData = Security(api_nei_auth),
) -> Table:
    """Reserves a seat on table"""
    table_person = TablePerson(
        id=auth_data.sub,
        dish=form_data.dish,
        allergies=form_data.allergies,
        companions=form_data.companions,
        confirmed=False,
    )

    person_update_cmd = table_person.dict()
    # Person is confirmed if the table is empty
    person_update_cmd["confirmed"] = table_queries.table_is_empty

    try:
        # Oportunistic path - Everything goes well
        res = await Table.get_collection(db).find_one_and_update(
            {"_id": table_id},
            [
                {
                    "$set": {
                        # Need to do a concat because $push doesn't support aggregate pipelines
                        "persons": {"$concatArrays": ["$persons", [person_update_cmd]]},
                        # Automatically assign the first person as head otherwise keep the previous
                        "head": {
                            "$cond": {
                                "if": table_queries.table_is_empty,
                                "then": table_person.id,
                                "else": "$head",
                            }
                        },
                    }
                },
            ],
            return_document=ReturnDocument.AFTER,
        )

        if res is None:
            raise NotFoundReCheck
    except (OperationFailure, NotFoundReCheck) as e:
        # Something went wrong - Check the reason and tell the client
        table = await fetch_table(table_id, db)

        if any(person.id == table_person.id for person in table.persons):
            raise HTTPException(status_code=409, detail="Already in table")

        occupied_seats = table.confirmed_seats()

        if len(table_person.companions) >= table.seats:
            raise HTTPException(
                status_code=400, detail="There aren't enough seats for the companions"
            )

        if occupied_seats >= table.seats:
            raise HTTPException(status_code=409, detail="Table full")

        if await person_in_table(table_person.id, db):
            raise HTTPException(status_code=409, detail="Already in a table")

        logger.error(e)

        raise HTTPException(status_code=500, detail="Something went wrong")

    table = Table.parse_obj(res)
    return sanitize_table(auth_data, table)
