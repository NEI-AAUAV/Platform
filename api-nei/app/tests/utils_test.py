"""Contracts of the shared helpers in app.utils."""
import io
import zipfile
from typing import Optional

import pytest
from pydantic import BaseModel, ValidationError

from app.utils import (
    CustomZipFile,
    EnumList,
    ValidateFromJson,
    _decode_filename,
    include,
    list_zip_contents,
    optional,
)


class _Color(EnumList):
    RED = "red"
    BLUE = "blue"


def test_enum_list_returns_values_not_members() -> None:
    assert _Color.list() == ["red", "blue"]


def test_decode_filename_prefers_utf8() -> None:
    assert _decode_filename("ação.txt".encode("utf-8")) == "ação.txt"


def test_decode_filename_falls_back_to_cp1252() -> None:
    # b"\xe7" alone is invalid utf-8 but is 'ç' in cp1252
    assert _decode_filename(b"a\xe7o") == "aço"


class _Stamped(BaseModel):
    name: str
    created_at: Optional[str] = None


def test_include_keeps_field_even_when_excluded_by_exclude_none() -> None:
    decorated = include(["created_at"])(_Stamped)

    dumped = decorated(name="x").model_dump(exclude_none=True)

    assert dumped == {"name": "x", "created_at": None}


def test_include_does_not_override_fields_already_dumped() -> None:
    decorated = include(["created_at"])(
        type("_S2", (_Stamped,), {})
    )

    assert decorated(name="x", created_at="t").model_dump()["created_at"] == "t"


class _FromJson(ValidateFromJson, BaseModel):
    a: int


def test_validate_from_json_accepts_dict_untouched() -> None:
    assert _FromJson.model_validate({"a": 1}).a == 1


def test_validate_from_json_parses_stringified_payload() -> None:
    assert _FromJson.model_validate('{"a": 2}').a == 2


def test_validate_from_json_rejects_invalid_json() -> None:
    with pytest.raises(ValueError):
        _FromJson.model_validate("{not json")


def test_optional_makes_fields_optional_with_none_default() -> None:
    @optional()
    class Model(BaseModel):
        a: int
        b: str

    m = Model()

    assert m.a is None and m.b is None


def test_optional_keeps_excluded_fields_required() -> None:
    @optional(exclude={"a"})
    class Model(BaseModel):
        a: int
        b: str

    with pytest.raises(ValidationError):
        Model()
    assert Model(a=1).b is None


def _zip_with_raw_name(raw_name: bytes) -> io.BytesIO:
    """Build a zip then patch the stored filename bytes (no utf-8 flag)."""
    buf = io.BytesIO()
    with zipfile.ZipFile(buf, "w") as z:
        z.writestr("PLACEHOLDER", b"data")
    data = buf.getvalue().replace(b"PLACEHOLDER", raw_name.ljust(11, b"_")[:11])
    return io.BytesIO(data)


def test_list_zip_contents_lists_plain_entries() -> None:
    buf = io.BytesIO()
    with zipfile.ZipFile(buf, "w") as z:
        z.writestr("a.txt", "1")
        z.writestr("dir/b.txt", "2")

    assert list_zip_contents(buf) == ["a.txt", "dir/b.txt"]


def test_list_zip_contents_decodes_legacy_encoded_names() -> None:
    raw = "açao".encode("cp1252")  # not valid utf-8
    names = list_zip_contents(_zip_with_raw_name(raw))

    assert names[0].startswith("açao")


def test_custom_zip_rejects_non_zip_data() -> None:
    with pytest.raises(zipfile.BadZipFile):
        CustomZipFile(io.BytesIO(b"definitely not a zip file"))
