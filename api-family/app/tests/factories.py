"""Tiny helpers to seed the (empty, per-test) Mongo database."""

from typing import Optional

from app.db.db import Course, Role, User, UserRole


def make_user(
    id: int,
    name: str = "Ana Silva",
    *,
    sex: str = "M",
    start_year: Optional[int] = 20,
    patrao_id: Optional[int] = None,
    **extra,
) -> dict:
    doc = {
        "_id": id,
        "name": name,
        "sex": sex,
        "start_year": start_year,
        "patrao_id": patrao_id,
        "faina_name": name.split()[-1],
        **extra,
    }
    User.insert_one(doc)
    return doc


def make_role(
    id: str,
    name: str,
    *,
    super_roles: str = "",
    short: Optional[str] = None,
    **extra,
) -> dict:
    doc = {
        "_id": id,
        "name": name,
        "short": short,
        "super_roles": super_roles,
        "show": False,
        "year_display_format": "civil",
        "hidden": False,
        **extra,
    }
    Role.insert_one(doc)
    return doc


def make_user_role(user_id: int, role_id: str, year: int = 20) -> str:
    return str(
        UserRole.insert_one({"user_id": user_id, "role_id": role_id, "year": year}).inserted_id
    )


def make_course(
    id: int, short: str, *, degree: str = "Licenciatura", show: bool = False
) -> dict:
    doc = {"_id": id, "short": short, "name": f"Course {short}", "degree": degree, "show": show}
    Course.insert_one(doc)
    return doc
