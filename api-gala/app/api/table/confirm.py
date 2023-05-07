from fastapi import APIRouter, Security, HTTPException
from pydantic import BaseModel
from pymongo import ReturnDocument
from pymongo.errors import OperationFailure

from app.models.table import Table
from app.api.auth import AuthData, api_nei_auth
from app.core.db import DatabaseDep
from app.core.logging import logger
import app.queries.table as table_queries

from ._utils import (
    sanitize_table,
    fetch_table,
    query_check_table_head_permissions,
    head_permission_check,
    NotFoundReCheck,
)

router = APIRouter()


class TableApprovalForm(BaseModel):
    uid: int
    confirm: bool


@router.patch(
    "/{table_id}/confirm",
    responses={
        400: {
            "description": "The status of the table head cannot be changed or the person doesn't belong to the table"
        },
        403: {"description": "The user doesn't have enough permissions"},
        404: {"description": "Table not found"},
    },
)
async def person_confirm_table(
    table_id: int,
    form_data: TableApprovalForm,
    *,
    db: DatabaseDep,
    auth: AuthData = Security(api_nei_auth),
) -> Table:
    """Set the status of a person on a table"""
    table_is_full = {"$eq": [table_queries.num_confirmed_persons, "$seats"]}
    map_update_person_predicate = {
        "$cond": {
            "if": {"$eq": ["$$person.id", form_data.uid]},
            "then": {
                "$mergeObjects": [
                    "$$person",
                    {"confirmed": form_data.confirm},
                ]
            },
            "else": "$$person",
        }
    }

    try:
        # Oportunistic path - Everything goes well
        res = await Table.get_collection(db).find_one_and_update(
            query_check_table_head_permissions(auth, {"_id": table_id}),
            [
                # 1. Update the person to be confirmed
                {
                    "$set": {
                        "persons": {
                            "$map": {
                                "input": "$persons",
                                "as": "person",
                                "in": map_update_person_predicate,
                            }
                        },
                    }
                },
                # 2. If the table is full remove all non confirmed persons
                {
                    "$set": {
                        "persons": {
                            "$cond": {
                                "if": table_is_full,
                                "then": table_queries.confirmed_persons_array,
                                "else": "$persons",
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
        head_permission_check(auth, table)

        if table.head == form_data.uid:
            raise HTTPException(
                status_code=400, detail="The status of the table head cannot be changed"
            )

        logger.error(e)

        raise HTTPException(status_code=500, detail="Something went wrong")

    table = Table.parse_obj(res)

    if all(person.id != form_data.uid for person in table.persons):
        raise HTTPException(
            status_code=400, detail="The person doesn't belong to the table"
        )

    return sanitize_table(auth, table)
