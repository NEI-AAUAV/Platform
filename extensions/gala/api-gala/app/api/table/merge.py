from fastapi import APIRouter, Security, HTTPException
from pydantic import BaseModel
from pymongo import ReturnDocument
from pymongo.errors import OperationFailure

from app.models.table import Table
from app.api.auth import AuthData, api_nei_auth, auth_responses
from app.core.db import DatabaseDep
from app.core.logging import logger
from app.utils import NotFoundReCheck

from ._utils import (
    sanitize_table,
    fetch_table,
)

router = APIRouter()


class TableMergeForm(BaseModel):
    tid: int
    # Merge tables, even if there is no space left, and increase the table size
    force_merge: bool = False


@router.post(
    "/{table_id}/merge",
    responses={
        **auth_responses,
        404: {"description": "Table not found"},
        409: {"description": "Cannot merge table with itself"},
        409: {"description": "Cannot merge empty tables"},
        409: {"description": "No space available to merge tables"},
    },
)
async def merge_table(
    table_id: int,
    form_data: TableMergeForm,
    *,
    db: DatabaseDep,
    auth: AuthData = Security(api_nei_auth),
) -> Table:
    """Merges a table with another"""

    if table_id == form_data.tid:
        raise HTTPException(status_code=409, detail="Cannot merge table with itself")

    table1 = await fetch_table(table_id, db)
    table2 = await fetch_table(form_data.tid, db)

    if table1 is None or table2 is None:
        raise HTTPException(status_code=404, detail="Table not found")

    if table1.head is None or table2.head is None:
        raise HTTPException(status_code=409, detail="Cannot merge empty tables")

    if (
        not form_data.force_merge
        and table1.seats - table1.confirmed_seats() < table2.confirmed_seats()
    ):
        raise HTTPException(
            status_code=409, detail="No space available to merge tables"
        )

    table1_missing_seats = table2.confirmed_seats() - (
        table1.seats - table1.confirmed_seats()
    )
    table2_persons = [p.dict() for p in table2.persons if p.confirmed]

    try:
        # Oportunistic path - Everything goes well
        res = await Table.get_collection(db).find_one_and_update(
            {"_id": form_data.tid},
            [
                {
                    "$set": {
                        "persons": [],
                        "head": None,
                    }
                },
            ],
            return_document=ReturnDocument.AFTER,
        )
        if res is None:
            raise OperationFailure("Something went wrong")

        res = await Table.get_collection(db).find_one_and_update(
            {"_id": table_id},
            [
                {
                    "$set": {
                        "persons": {"$concatArrays": ["$persons", table2_persons]},
                        "seats": {
                            "$cond": {
                                "if": table1_missing_seats > 0,
                                "then": {"$add": ["$seats", table1_missing_seats]},
                                "else": "$seats",
                            },
                        },
                    }
                },
            ],
            return_document=ReturnDocument.AFTER,
        )
        if res is None:
            raise OperationFailure("Something went wrong")

    except OperationFailure as e:
        # Something went wrong - Do not check reason cause it should've work
        logger.error(e)
        raise HTTPException(status_code=500, detail="Something went wrong")

    table = Table.parse_obj(res)
    return sanitize_table(auth, table)
