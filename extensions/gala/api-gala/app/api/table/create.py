from fastapi import APIRouter, Security
from pydantic import BaseModel, PositiveInt

from app.models.table import Table
from app.api.auth import AuthData, api_nei_auth, ScopeEnum
from app.core.db import DatabaseDep
from app.core.db.counters import getNextTabledId

router = APIRouter()


class TableCreateForm(BaseModel):
    seats: PositiveInt


@router.post("/new")
async def create_table(
    form_data: TableCreateForm,
    *,
    db: DatabaseDep,
    _: AuthData = Security(api_nei_auth, scopes=[ScopeEnum.MANAGER_JANTAR_GALA]),
) -> Table:
    """Creates a new table"""
    id = await getNextTabledId(db)
    table = Table(
        _id=id,
        name=None,
        head=None,
        seats=form_data.seats,
        persons=[],
    )

    await Table.get_collection(db).insert_one(table.dict(by_alias=True))

    return table
