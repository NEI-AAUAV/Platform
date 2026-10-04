"""User-role endpoints: referential checks, duplicates and detail joins."""

import pytest
from fastapi.testclient import TestClient

from app.core.config import settings
from app.tests.factories import make_role, make_user, make_user_role

BASE = f"{settings.API_V1_STR}/userrole"


@pytest.fixture(autouse=True)
def seeded() -> None:
    make_user(1, "Ana Silva", sex="F")
    make_user(2, "Bruno Costa")
    make_role(".1.", "Faina", short="FAINA")
    make_role(".1.2.", "Mestre", super_roles=".1.")


def _create(client: TestClient, user_id=1, role_id=".1.", year=20):
    return client.post(f"{BASE}/", json={"user_id": user_id, "role_id": role_id, "year": year})


def test_create_returns_201_with_string_id(auth_client: TestClient) -> None:
    r = _create(auth_client)

    assert r.status_code == 201
    body = r.json()
    assert isinstance(body["id"], str)
    assert len(body["id"]) == 24
    assert (body["user_id"], body["role_id"], body["year"]) == (1, ".1.", 20)


def test_unknown_user_or_role_is_404(auth_client: TestClient) -> None:
    assert _create(auth_client, user_id=99).status_code == 404
    assert _create(auth_client, role_id=".9.").status_code == 404


def test_duplicate_assignment_is_409_but_other_year_is_fine(auth_client: TestClient) -> None:
    _create(auth_client)

    assert _create(auth_client).status_code == 409
    assert _create(auth_client, year=21).status_code == 201


@pytest.mark.parametrize(
    "body",
    [
        {"user_id": 1, "role_id": "1", "year": 20},
        {"user_id": 1, "role_id": ".a.", "year": 20},
        {"user_id": 1, "role_id": ".1.", "year": 100},
        {"user_id": 1, "role_id": ".1.", "year": -1},
        {"user_id": 1, "role_id": ".1."},
    ],
    ids=["no-dots", "non-numeric", "year-too-big", "negative-year", "missing-year"],
)
def test_invalid_payload_is_422(auth_client: TestClient, body) -> None:
    assert auth_client.post(f"{BASE}/", json=body).status_code == 422


def test_listing_filters_and_reports_filtered_total(auth_client: TestClient) -> None:
    make_user_role(1, ".1.", 20)
    make_user_role(1, ".1.2.", 21)
    make_user_role(2, ".1.", 21)

    by_user = auth_client.get(f"{BASE}/", params={"user_id": 1}).json()
    by_year_zero = auth_client.get(f"{BASE}/", params={"year": 21, "role_id": ".1."}).json()
    paged = auth_client.get(f"{BASE}/", params={"limit": 1, "skip": 1}).json()

    assert by_user["total"] == 2
    assert len(by_user["items"]) == 2
    assert by_year_zero["total"] == 1
    assert len(paged["items"]) == 1
    assert paged["total"] == 3


def test_listing_validates_filters(auth_client: TestClient) -> None:
    assert auth_client.get(f"{BASE}/", params={"year": 100}).status_code == 422
    assert auth_client.get(f"{BASE}/", params={"limit": 501}).status_code == 422


def test_details_expose_user_and_role_info(auth_client: TestClient) -> None:
    make_user_role(1, ".1.2.", 20)

    r = auth_client.get(f"{BASE}/details")

    assert r.status_code == 200
    item = r.json()["items"][0]
    assert item["user_name"] == "Ana Silva"
    assert item["user"]["id"] == 1
    assert item["user"]["name"] == "Ana Silva"
    assert item["role_name"] == "Mestre"


def test_roles_for_user(auth_client: TestClient) -> None:
    make_user_role(1, ".1.", 20)
    make_user_role(2, ".1.", 20)

    ok = auth_client.get(f"{BASE}/user/1")
    missing = auth_client.get(f"{BASE}/user/99")

    assert ok.json()["total"] == 1
    assert ok.json()["items"][0]["user_id"] == 1
    assert missing.status_code == 404


def test_users_for_role_supports_path_ids(auth_client: TestClient) -> None:
    make_user_role(1, ".1.2.", 20)
    make_user_role(2, ".1.", 20)

    ok = auth_client.get(f"{BASE}/role/.1.2.")
    missing = auth_client.get(f"{BASE}/role/.9.")

    assert ok.status_code == 200
    assert [i["user_id"] for i in ok.json()["items"]] == [1]
    assert missing.status_code == 404


def test_delete_assignment(auth_client: TestClient) -> None:
    doc_id = make_user_role(1, ".1.", 20)

    assert auth_client.delete(f"{BASE}/{doc_id}").status_code == 204
    assert auth_client.delete(f"{BASE}/{doc_id}").status_code == 404
    assert auth_client.delete(f"{BASE}/not-an-id").status_code == 404


@pytest.mark.parametrize(
    "method,path",
    [("get", "/"), ("get", "/details"), ("get", "/user/1"), ("get", "/role/.1."),
     ("post", "/"), ("delete", "/" + "a" * 24)],
)
def test_all_user_role_endpoints_require_authentication(client: TestClient, method, path) -> None:
    assert client.request(method, f"{BASE}{path}", json={}).status_code == 401
