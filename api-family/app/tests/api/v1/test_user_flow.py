"""User endpoints: validation, referential integrity, bulk import, images, tree."""

from datetime import datetime
from io import BytesIO
from unittest.mock import MagicMock

import pytest
from fastapi.testclient import TestClient
from PIL import Image

from app.core.config import settings
from app.tests.factories import make_course, make_role, make_user, make_user_role

BASE = f"{settings.API_V1_STR}/user"
TREE = f"{settings.API_V1_STR}/tree"
BODY = {"name": "Ana Maria Silva", "sex": "F", "start_year": 20}


# ----------------------------------------------------------------------- create


def test_create_returns_201_and_defaults_faina_name(auth_client: TestClient) -> None:
    r = auth_client.post(f"{BASE}/", json=BODY)

    assert r.status_code == 201
    body = r.json()
    assert body["id"] == 1
    assert body["faina_name"] == "Silva"
    assert body["user_roles"] == []


@pytest.mark.parametrize(
    "patch",
    [
        {"sex": "X"},
        {"start_year": 100},
        {"start_year": -1},
        {"name": "x" * 101},
        {"faina_name": "x" * 51},
    ],
)
def test_create_validates_payload(auth_client: TestClient, patch) -> None:
    assert auth_client.post(f"{BASE}/", json={**BODY, **patch}).status_code == 422


def test_create_requires_name_and_sex(auth_client: TestClient) -> None:
    assert auth_client.post(f"{BASE}/", json={"name": "x"}).status_code == 422


def test_create_with_missing_patrao_is_400(auth_client: TestClient) -> None:
    r = auth_client.post(f"{BASE}/", json={**BODY, "patrao_id": 99})

    assert r.status_code == 400
    assert "99" in r.json()["detail"]


def test_create_with_missing_course_is_400(auth_client: TestClient) -> None:
    assert auth_client.post(f"{BASE}/", json={**BODY, "course_id": 99}).status_code == 400


def test_create_with_existing_patrao_and_course(auth_client: TestClient) -> None:
    make_user(1, "Patrao")
    make_course(7, "LEI")

    r = auth_client.post(f"{BASE}/", json={**BODY, "patrao_id": 1, "course_id": 7})

    assert r.status_code == 201
    assert r.json()["patrao_id"] == 1


def test_nmec_must_be_unique(auth_client: TestClient) -> None:
    auth_client.post(f"{BASE}/", json={**BODY, "nmec": 1234})

    r = auth_client.post(f"{BASE}/", json={**BODY, "name": "Other Person", "nmec": 1234})

    assert r.status_code == 400
    assert "1234" in r.json()["detail"]


# ------------------------------------------------------------------------- read


def test_get_user_with_roles_and_404(auth_client: TestClient) -> None:
    make_user(1, "Ana Silva")

    ok = auth_client.get(f"{BASE}/1")

    assert ok.status_code == 200
    assert ok.json()["name"] == "Ana Silva"
    assert auth_client.get(f"{BASE}/99").status_code == 404


def test_listing_filters_search_and_total(auth_client: TestClient) -> None:
    make_user(1, "Ana Silva", start_year=18)
    make_user(2, "Bruno Silva", start_year=19, patrao_id=1)
    make_user(3, "Carla Dias", start_year=20)

    silva = auth_client.get(f"{BASE}/", params={"search": "silva"}).json()
    from_19 = auth_client.get(f"{BASE}/", params={"from_year": 19}).json()
    kids = auth_client.get(f"{BASE}/", params={"patrao_id": 1}).json()
    page = auth_client.get(f"{BASE}/", params={"limit": 1, "skip": 1, "sort_by": "id"}).json()

    assert {u["id"] for u in silva["items"]} == {1, 2}
    assert silva["total"] == 2
    assert {u["id"] for u in from_19["items"]} == {2, 3}
    assert [u["id"] for u in kids["items"]] == [2]
    assert [u["id"] for u in page["items"]] == [2]
    assert page["total"] == 3


def test_listing_filters_by_role(auth_client: TestClient) -> None:
    make_role(".1.", "Faina", short="F")
    make_user(1, "A")
    make_user(2, "B")
    make_user_role(1, ".1.", 20)

    r = auth_client.get(f"{BASE}/", params={"role_id": ".1.", "role_year": 20}).json()

    assert [u["id"] for u in r["items"]] == [1]
    assert r["total"] == 1
    assert r["items"][0]["user_roles"][0]["org_name"] == "F"


def test_listing_validates_pagination(auth_client: TestClient) -> None:
    assert auth_client.get(f"{BASE}/", params={"limit": 501}).status_code == 422
    assert auth_client.get(f"{BASE}/", params={"limit": 0}).status_code == 422
    assert auth_client.get(f"{BASE}/", params={"skip": -1}).status_code == 422


def test_years_endpoint_is_not_shadowed_by_the_id_route(auth_client: TestClient) -> None:
    make_user(1, "A", start_year=18)
    make_user(2, "B", start_year=20)

    r = auth_client.get(f"{BASE}/years")

    assert r.status_code == 200
    assert r.json() == [20, 18]


def test_children_endpoint(auth_client: TestClient) -> None:
    make_user(1, "Patrao")
    make_user(2, "Child", patrao_id=1)

    assert [u["id"] for u in auth_client.get(f"{BASE}/1/children").json()] == [2]
    assert auth_client.get(f"{BASE}/2/children").json() == []
    assert auth_client.get(f"{BASE}/99/children").status_code == 404


# ----------------------------------------------------------------------- update


def test_update_changes_only_sent_fields(auth_client: TestClient) -> None:
    make_user(1, "Old Name", nmec=5)

    r = auth_client.put(f"{BASE}/1", json={"name": "New Name"})

    assert r.status_code == 200
    assert (r.json()["name"], r.json()["nmec"]) == ("New Name", 5)


def test_update_unknown_user_is_404(auth_client: TestClient) -> None:
    assert auth_client.put(f"{BASE}/99", json={"name": "x"}).status_code == 404


def test_user_cannot_be_own_patrao(auth_client: TestClient) -> None:
    make_user(1, "A")

    r = auth_client.put(f"{BASE}/1", json={"patrao_id": 1})

    assert r.status_code == 400
    assert "own patrão" in r.json()["detail"]


def test_update_with_missing_patrao_or_course_is_400(auth_client: TestClient) -> None:
    make_user(1, "A")

    assert auth_client.put(f"{BASE}/1", json={"patrao_id": 99}).status_code == 400
    assert auth_client.put(f"{BASE}/1", json={"course_id": 99}).status_code == 400


def test_update_cannot_create_a_cycle_in_the_family_tree(auth_client: TestClient) -> None:
    make_user(1, "Root")
    make_user(2, "Child", patrao_id=1)
    make_user(3, "Grandchild", patrao_id=2)

    r = auth_client.put(f"{BASE}/1", json={"patrao_id": 3})

    assert r.status_code == 400
    assert "cycle" in r.json()["detail"]
    assert auth_client.get(f"{BASE}/1").json()["patrao_id"] is None


def test_update_may_move_user_to_another_branch(auth_client: TestClient) -> None:
    make_user(1, "Root")
    make_user(2, "A", patrao_id=1)
    make_user(3, "B", patrao_id=1)

    r = auth_client.put(f"{BASE}/3", json={"patrao_id": 2})

    assert r.status_code == 200
    assert r.json()["patrao_id"] == 2


def test_nmec_uniqueness_on_update_ignores_the_user_itself(auth_client: TestClient) -> None:
    make_user(1, "A", nmec=111)
    make_user(2, "B", nmec=222)

    same = auth_client.put(f"{BASE}/1", json={"nmec": 111})
    taken = auth_client.put(f"{BASE}/1", json={"nmec": 222})

    assert same.status_code == 200
    assert taken.status_code == 400


def test_update_validates_payload(auth_client: TestClient) -> None:
    make_user(1, "A")

    assert auth_client.put(f"{BASE}/1", json={"sex": "Z"}).status_code == 422
    assert auth_client.put(f"{BASE}/1", json={"end_year": 100}).status_code == 422


# ----------------------------------------------------------------------- delete


def test_delete_leaf_user(auth_client: TestClient) -> None:
    make_user(1, "A")

    assert auth_client.delete(f"{BASE}/1").status_code == 204
    assert auth_client.get(f"{BASE}/1").status_code == 404


def test_delete_unknown_user_is_404(auth_client: TestClient) -> None:
    assert auth_client.delete(f"{BASE}/99").status_code == 404


def test_cannot_delete_user_that_still_has_children(auth_client: TestClient) -> None:
    make_user(1, "Patrao")
    make_user(2, "Child", patrao_id=1)

    r = auth_client.delete(f"{BASE}/1")

    assert r.status_code == 400
    assert "1 children" in r.json()["detail"]
    assert auth_client.get(f"{BASE}/1").status_code == 200


# ------------------------------------------------------------------------- bulk


def _row(name: str, **kw) -> dict:
    return {"name": name, "sex": "M", "start_year": 20, **kw}


def test_bulk_creates_every_valid_row(auth_client: TestClient) -> None:
    r = auth_client.post(f"{BASE}/bulk", json=[_row("Ana Silva"), _row("Rui Costa")])

    assert r.status_code == 201
    body = r.json()
    assert (body["total_submitted"], body["total_created"], body["total_errors"]) == (2, 2, 0)
    assert [u["id"] for u in body["created"]] == [1, 2]
    assert body["dry_run"] is False


def test_bulk_rows_can_reference_users_created_earlier_in_the_same_batch(
    auth_client: TestClient,
) -> None:
    make_user(1, "Existing")

    r = auth_client.post(f"{BASE}/bulk", json=[_row("Child One", patrao_id=1)])

    assert r.json()["created"][0]["patrao_id"] == 1


def test_bulk_reports_row_level_errors_and_keeps_valid_rows(auth_client: TestClient) -> None:
    future = (datetime.now().year % 100) + 1
    rows = [
        _row("Good One"),
        _row("Future Person", start_year=future),
        _row("No Patrao", patrao_id=404),
        _row("No Course", course_id=404),
    ]

    body = auth_client.post(f"{BASE}/bulk", json=rows).json()

    assert body["total_created"] == 1
    assert body["total_errors"] == 3
    errors = {e["row"]: e for e in body["errors"]}
    assert set(errors) == {1, 2, 3}
    assert "futuro" in errors[1]["message"]
    assert "404" in errors[2]["message"]
    assert "404" in errors[3]["message"]
    assert errors[2]["data"]["name"] == "No Patrao"


def test_bulk_detects_duplicate_nmec_in_batch_and_in_database(auth_client: TestClient) -> None:
    make_user(1, "Existing", nmec=777)

    body = auth_client.post(
        f"{BASE}/bulk",
        json=[_row("First One", nmec=555), _row("Second One", nmec=555), _row("Third One", nmec=777)],
    ).json()

    assert body["total_created"] == 1
    messages = {e["row"]: e["message"] for e in body["errors"]}
    assert "duplicado" in messages[1]
    assert "já existe" in messages[2]


def test_bulk_warns_about_duplicate_names_without_failing(auth_client: TestClient) -> None:
    body = auth_client.post(f"{BASE}/bulk", json=[_row("Ana Silva"), _row(" ana silva ")]).json()

    assert body["total_created"] == 2
    assert body["warnings"] == ["Nome duplicado 'ana silva' nas linhas: 1, 2"]


def test_bulk_dry_run_changes_nothing(auth_client: TestClient) -> None:
    body = auth_client.post(
        f"{BASE}/bulk", params={"dry_run": True}, json=[_row("Ana Silva")]
    ).json()

    assert body["dry_run"] is True
    assert body["total_created"] == 1
    assert body["created"][0]["id"] == -1
    assert auth_client.get(f"{BASE}/").json()["total"] == 0


def test_bulk_atomic_aborts_everything_when_any_row_fails(auth_client: TestClient) -> None:
    rows = [_row("Good One"), _row("Bad One", patrao_id=404)]

    body = auth_client.post(f"{BASE}/bulk", params={"atomic": True}, json=rows).json()

    assert body["total_created"] == 0
    assert body["total_errors"] == 1
    assert auth_client.get(f"{BASE}/").json()["total"] == 0


def test_bulk_atomic_without_errors_creates_all(auth_client: TestClient) -> None:
    body = auth_client.post(f"{BASE}/bulk", params={"atomic": True}, json=[_row("Good One")]).json()

    assert body["total_created"] == 1


def test_bulk_rejects_more_than_100_rows(auth_client: TestClient) -> None:
    r = auth_client.post(f"{BASE}/bulk", json=[_row(f"Person {i}") for i in range(101)])

    assert r.status_code == 400
    assert "100" in r.json()["detail"]


def test_bulk_requires_start_year(auth_client: TestClient) -> None:
    assert auth_client.post(f"{BASE}/bulk", json=[{"name": "x", "sex": "M"}]).status_code == 422


def test_bulk_row_failure_during_creation_is_reported(auth_client: TestClient, monkeypatch) -> None:
    from app.api.v1 import user as user_api

    monkeypatch.setattr(
        user_api.crud_user, "create", MagicMock(side_effect=RuntimeError("db down"))
    )

    body = auth_client.post(f"{BASE}/bulk", json=[_row("Ana Silva")]).json()

    assert body["total_created"] == 0
    assert body["errors"][0]["message"] == "db down"


# ------------------------------------------------------------------------ image


def _png() -> bytes:
    buf = BytesIO()
    Image.new("RGB", (8, 8), "blue").save(buf, format="PNG")
    return buf.getvalue()


@pytest.fixture
def storage(monkeypatch) -> MagicMock:
    from app.crud import crud_user
    from app.services import storage as storage_mod

    mock = MagicMock(enabled=True)
    mock.upload_image.return_value = "https://cdn.test/u.jpg"
    monkeypatch.setattr(storage_mod, "storage_client", mock)
    monkeypatch.setattr(crud_user, "storage_client", mock)
    return mock


def test_image_upload_disabled_storage_is_503(auth_client: TestClient, monkeypatch) -> None:
    from app.services import storage as storage_mod

    monkeypatch.setattr(storage_mod, "storage_client", MagicMock(enabled=False))
    make_user(1, "A")

    r = auth_client.put(f"{BASE}/1/image", files={"image": ("a.png", _png(), "image/png")})

    assert r.status_code == 503


def test_image_upload_stores_the_new_url(auth_client: TestClient, storage) -> None:
    make_user(1, "A")

    r = auth_client.put(f"{BASE}/1/image", files={"image": ("a.png", _png(), "image/png")})

    assert r.status_code == 200
    assert r.json()["image"] == "https://cdn.test/u.jpg"


def test_image_remove_clears_it(auth_client: TestClient, storage) -> None:
    make_user(1, "A", image="https://cdn.test/old.jpg")

    r = auth_client.put(f"{BASE}/1/image", data={"remove": "true"})

    assert r.status_code == 200
    assert r.json()["image"] is None
    storage.delete_image.assert_called_once_with("https://cdn.test/old.jpg")


def test_image_and_remove_together_is_400(auth_client: TestClient, storage) -> None:
    make_user(1, "A")

    r = auth_client.put(
        f"{BASE}/1/image",
        files={"image": ("a.png", _png(), "image/png")},
        data={"remove": "true"},
    )

    assert r.status_code == 400


def test_image_for_unknown_user_is_404(auth_client: TestClient, storage) -> None:
    r = auth_client.put(f"{BASE}/99/image", files={"image": ("a.png", _png(), "image/png")})

    assert r.status_code == 404


# ------------------------------------------------------------------------- tree


def test_tree_endpoint_full_subtree_and_depth(auth_client: TestClient) -> None:
    make_user(1, "Root", start_year=18)
    make_user(2, "Child", start_year=19, patrao_id=1)
    make_user(3, "Grandchild", start_year=20, patrao_id=2)

    full = auth_client.get(f"{TREE}/").json()
    sub = auth_client.get(f"{TREE}/", params={"root_id": 2}).json()
    shallow = auth_client.get(f"{TREE}/", params={"depth": 0}).json()

    assert full["total_users"] == 3
    assert (full["min_year"], full["max_year"]) == (18, 20)
    assert full["roots"][0]["children"][0]["children"][0]["id"] == 3
    assert sub["total_users"] == 2
    assert sub["roots"][0]["id"] == 2
    assert shallow["roots"][0]["has_more_children"] is True


def test_tree_for_unknown_root_is_404(client: TestClient) -> None:
    assert client.get(f"{TREE}/", params={"root_id": 99}).status_code == 404


@pytest.mark.parametrize("depth", [-1, 51])
def test_tree_depth_is_bounded(client: TestClient, depth: int) -> None:
    assert client.get(f"{TREE}/", params={"depth": depth}).status_code == 422


def test_tree_is_public_and_empty_when_there_are_no_users(client: TestClient) -> None:
    r = client.get(f"{TREE}/")

    assert r.status_code == 200
    assert r.json() == {"roots": [], "total_users": 0, "min_year": 0, "max_year": 0}


# ------------------------------------------------------------------------- auth


@pytest.mark.parametrize(
    "method,path,body",
    [
        ("get", "/", None), ("get", "/years", None), ("get", "/1", None),
        ("get", "/1/children", None), ("post", "/", BODY), ("post", "/bulk", []),
        ("put", "/1", {"name": "x"}), ("delete", "/1", None),
    ],
)
def test_user_endpoints_require_authentication(client: TestClient, method, path, body) -> None:
    assert client.request(method, f"{BASE}{path}", json=body).status_code == 401
