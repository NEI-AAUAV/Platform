"""Course endpoints: lifecycle, conflicts and access control."""

import pytest
from fastapi.testclient import TestClient

from app.core.config import settings
from app.tests.factories import make_course

BASE = f"{settings.API_V1_STR}/course"
BODY = {"short": "LEI", "name": "Eng. Informática", "degree": "Licenciatura"}


def test_create_returns_201_with_id_alias_and_defaults(auth_client: TestClient) -> None:
    r = auth_client.post(f"{BASE}/", json=BODY)

    assert r.status_code == 201
    assert r.json() == {"id": 1, "short": "LEI", "name": "Eng. Informática",
                        "degree": "Licenciatura", "show": False}


def test_duplicate_short_is_409(auth_client: TestClient) -> None:
    auth_client.post(f"{BASE}/", json=BODY)

    r = auth_client.post(f"{BASE}/", json={**BODY, "name": "Other"})

    assert r.status_code == 409
    assert "LEI" in r.json()["detail"]


@pytest.mark.parametrize(
    "patch",
    [
        {"degree": "Bacharelato"},
        {"short": "TOOLONGSHORT"},
        {"short": None},
    ],
    ids=["unknown-degree", "short-too-long", "short-missing"],
)
def test_invalid_payload_is_422(auth_client: TestClient, patch) -> None:
    body = {**BODY, **patch}
    body = {k: v for k, v in body.items() if v is not None}

    assert auth_client.post(f"{BASE}/", json=body).status_code == 422


def test_get_by_id_and_404(auth_client: TestClient) -> None:
    make_course(5, "LEI")

    assert auth_client.get(f"{BASE}/5").json()["short"] == "LEI"
    r = auth_client.get(f"{BASE}/99")
    assert r.status_code == 404
    assert "99" in r.json()["detail"]


def test_listing_filters_and_total_follow_the_filter(auth_client: TestClient) -> None:
    make_course(1, "LEI", degree="Licenciatura", show=True)
    make_course(2, "MEI", degree="Mestrado", show=True)
    make_course(3, "LECI", degree="Licenciatura")

    everything = auth_client.get(f"{BASE}/").json()
    masters = auth_client.get(f"{BASE}/", params={"degree": "Mestrado"}).json()
    visible = auth_client.get(f"{BASE}/", params={"show_only": True}).json()
    page = auth_client.get(f"{BASE}/", params={"skip": 1, "limit": 1}).json()

    assert everything["total"] == 3
    assert [c["short"] for c in masters["items"]] == ["MEI"]
    assert masters["total"] == 1
    assert {c["short"] for c in visible["items"]} == {"LEI", "MEI"}
    assert visible["total"] == 2
    assert len(page["items"]) == 1
    assert page["total"] == 3
    assert (page["skip"], page["limit"]) == (1, 1)


@pytest.mark.parametrize("params", [{"skip": -1}, {"limit": 0}, {"limit": 1001}])
def test_listing_validates_pagination(auth_client: TestClient, params) -> None:
    assert auth_client.get(f"{BASE}/", params=params).status_code == 422


def test_update_changes_fields(auth_client: TestClient) -> None:
    make_course(1, "LEI")

    r = auth_client.put(f"{BASE}/1", json={"name": "Renamed", "show": True})

    assert r.status_code == 200
    assert (r.json()["name"], r.json()["show"], r.json()["short"]) == ("Renamed", True, "LEI")


def test_update_keeping_own_short_is_not_a_conflict(auth_client: TestClient) -> None:
    make_course(1, "LEI")

    assert auth_client.put(f"{BASE}/1", json={"short": "LEI"}).status_code == 200


def test_update_to_another_courses_short_is_409(auth_client: TestClient) -> None:
    make_course(1, "LEI")
    make_course(2, "MEI")

    assert auth_client.put(f"{BASE}/2", json={"short": "LEI"}).status_code == 409


def test_update_unknown_course_is_404(auth_client: TestClient) -> None:
    assert auth_client.put(f"{BASE}/9", json={"name": "x"}).status_code == 404


def test_delete_then_404(auth_client: TestClient) -> None:
    make_course(1, "LEI")

    first = auth_client.delete(f"{BASE}/1")
    second = auth_client.delete(f"{BASE}/1")

    assert first.status_code == 204
    assert first.content == b""
    assert second.status_code == 404


@pytest.mark.parametrize(
    "method,path,body",
    [
        ("get", "/", None), ("get", "/1", None), ("post", "/", BODY),
        ("put", "/1", {"name": "x"}), ("delete", "/1", None),
    ],
)
def test_all_course_endpoints_require_authentication(
    client: TestClient, method, path, body
) -> None:
    r = client.request(method, f"{BASE}{path}", json=body)

    assert r.status_code == 401
