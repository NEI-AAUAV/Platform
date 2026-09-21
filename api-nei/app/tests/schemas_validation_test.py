"""Pydantic must not be laxer than the constraints the database enforces.

Anything it lets through reaches Postgres, where a violation is at best a
generic 400 and at worst -- for a DataError, which is not an IntegrityError --
an unhandled 500.
"""
import pytest
from pydantic import BaseModel, ValidationError

from app.schemas.faina.faina_member import FainaMemberCreate
from app.schemas.team.team_member import TeamMemberCreate
from app.schemas.types import MandateStr


class _Mandate(BaseModel):
    m: MandateStr


@pytest.mark.parametrize("value", ["2025", "2025/26"])
def test_mandate_accepts_both_recorded_formats(value: str) -> None:
    assert _Mandate(m=value).m == value


@pytest.mark.parametrize("value", ["٢٠٢٥", "20a5", "2025-26", "25/26", "2025/2"])
def test_mandate_rejects_what_the_database_rejects(value: str) -> None:
    """The DB uses [0-9]; pydantic's \\d would also match Unicode digits."""
    with pytest.raises(ValidationError):
        _Mandate(m=value)


@pytest.mark.parametrize("field", ["name", "role"])
def test_team_member_text_is_length_bounded(field: str) -> None:
    """The columns are String(120); an over-long value is a DataError, not a 400."""
    payload = {"section_id": 1, "name": "Ana", "role": "Vogal", field: "x" * 121}
    with pytest.raises(ValidationError):
        TeamMemberCreate(**payload)


@pytest.mark.parametrize("blank", ["", "   "])
def test_team_member_name_cannot_be_blank(blank: str) -> None:
    with pytest.raises(ValidationError):
        TeamMemberCreate(section_id=1, name=blank, role="Vogal")


def test_team_member_name_is_stripped() -> None:
    assert TeamMemberCreate(section_id=1, name="  Ana  ", role="Vogal").name == "Ana"


def test_faina_member_name_is_length_bounded() -> None:
    with pytest.raises(ValidationError):
        FainaMemberCreate(faina_id=1, role_id=1, name="x" * 121)


def test_team_member_update_rejects_unknown_fields() -> None:
    """Without extra=forbid a stale PUT body yields 200 having changed nothing."""
    from app.schemas.team.team_member import TeamMemberUpdate

    with pytest.raises(ValidationError):
        TeamMemberUpdate(role_id=3)


@pytest.mark.parametrize("value", ["ATA", "PAO", "RAC"])
def test_rgm_category_accepts_the_three_valid_values(value: str) -> None:
    from app.schemas.rgm import RgmCategoryEnum

    assert RgmCategoryEnum(value).value == value


def test_rgm_category_rejects_anything_else() -> None:
    from app.schemas.rgm import RgmCategoryEnum

    with pytest.raises(ValueError):
        RgmCategoryEnum("XXX")


def test_rgm_response_tolerates_a_legacy_category() -> None:
    """Production holds rows predating ck_rgm_category_valid (e.g. 'CON').

    Typing the response field as the enum turns one stale row into a 500 for
    the entire listing, since FastAPI validates the whole response model.
    """
    from datetime import datetime

    from app.schemas.rgm import RgmInDB

    row = RgmInDB.model_validate(
        {
            "id": 61,
            "category": "CON",
            "mandate": "2024/25",
            "mandate_id": 1,
            "file": "/rgm/PAO/x.pdf",
            "date": datetime(2024, 1, 1),
            "title": "t",
        }
    )

    assert row.category == "CON"
