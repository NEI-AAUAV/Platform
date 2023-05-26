from fastapi import APIRouter, BackgroundTasks, Security, HTTPException
from pydantic import BaseModel
from pymongo import ReturnDocument
from pymongo.errors import OperationFailure

import app.queries.table as table_queries
from app.core.db import DatabaseDep
from app.core.logging import logger
from app.core.email import send_email
from app.core.config import SettingsDep
from app.models.table import Table
from app.models.user import User
from app.api.auth import AuthData, api_nei_auth, auth_responses
from app.utils import NotFoundReCheck

from ._utils import (
    sanitize_table,
    fetch_table,
    query_check_table_head_permissions,
    head_permission_check,
)

router = APIRouter()


class TableApprovalForm(BaseModel):
    uid: int
    confirm: bool


@router.patch(
    "/{table_id}/confirm",
    responses={
        **auth_responses,
        400: {
            "description": "The status of the table head cannot be changed or the person doesn't belong to the table"
        },
        404: {"description": "Table not found"},
    },
)
async def person_confirm_table(
    table_id: int,
    form_data: TableApprovalForm,
    *,
    db: DatabaseDep,
    settings: SettingsDep,
    background_tasks: BackgroundTasks,
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

        person = next(person for person in table.persons if person.id == form_data.uid)

        if table.seats - table.confirmed_seats() < 1 + len(person.companions):
            raise HTTPException(status_code=409, detail="Table is full")

        logger.error(e)

        raise HTTPException(status_code=500, detail="Something went wrong")

    table = Table.parse_obj(res)

    maybe_person = next(
        (person for person in table.persons if person.id == form_data.uid), None
    )
    if maybe_person is None:
        raise HTTPException(
            status_code=400, detail="The person doesn't belong to the table"
        )

    if form_data.confirm:
        user_db = await User.get_collection(db).find_one({"_id": maybe_person.id})
        user = User.parse_obj(user_db)

        table_name = table.name

        if table_name is None:
            head_db = await User.get_collection(db).find_one({"_id": table.head})
            head = User.parse_obj(head_db)

            table_name = head.name

        background_tasks.add_task(
            send_email,
            user.email,
            "Foste aceite na mesa",
            settings=settings,
            template="accepted",
            name=user.name,
            table=table_name,
        )

    return sanitize_table(auth, table)
