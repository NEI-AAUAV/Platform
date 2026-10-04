"""Helpers used to shape documents (Mongo-style `_id`) and aliases."""
import pytest

from app.serializers import serialize_dict, serialize_list
from app.utils import to_camel_case


@pytest.mark.parametrize(
    "alias, expected",
    [
        ("name", "name"),
        ("created_at", "createdAt"),
        ("user_photo_url", "userPhotoUrl"),
        ("", ""),
    ],
)
def test_to_camel_case(alias: str, expected: str) -> None:
    assert to_camel_case(alias) == expected


class _ObjectId:
    def __str__(self) -> str:
        return "abc123"


def test_serialize_dict_stringifies_only_the_id() -> None:
    doc = {"_id": _ObjectId(), "n": 3}

    assert serialize_dict(doc) == {"_id": "abc123", "n": 3}


def test_serialize_dict_does_not_mutate_input() -> None:
    oid = _ObjectId()
    doc = {"_id": oid}

    serialize_dict(doc)

    assert doc["_id"] is oid


def test_serialize_dict_without_id_is_unchanged() -> None:
    assert serialize_dict({"a": 1}) == {"a": 1}


def test_serialize_list_maps_every_document() -> None:
    docs = [{"_id": 1, "a": "x"}, {"_id": 2}]

    assert serialize_list(docs) == [{"_id": "1", "a": "x"}, {"_id": "2"}]


def test_serialize_list_empty() -> None:
    assert serialize_list([]) == []
