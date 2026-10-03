"""Role endpoints: generated path ids, hierarchy integrity and access control."""

import pytest
from fastapi.testclient import TestClient

from app.core.config import settings
from app.tests.factories import make_role

BASE = f"{settings.API_V1_STR}/role"


def test_create_root_and_child_generate_path_ids(auth_client: TestClient) -> None:
    root = auth_client.post(f"{BASE}/", json={"name": "Faina"})
    child = auth_client.post(f"{BASE}/", json={"name": "CF", "super_roles": ".1."})

    assert root.status_code == 201 and root.json()["id"] == ".1."
    assert child.status_code == 201 and child.json()["id"] == ".1.1."
    assert child.json()["super_roles"] == ".1."


def test_create_under_missing_parent_is_400(auth_client: TestClient) -> None:
    r = auth_client.post(f"{BASE}/", json={"name": "X", "super_roles": ".9."})

    assert r.status_code == 400 and ".9." in r.json()["detail"]


def test_create_validates_field_lengths(auth_client: TestClient) -> None:
    assert auth_client.post(f"{BASE}/", json={"name": "x" * 101}).status_code == 422
    assert auth_client.post(f"{BASE}/", json={"name": "x", "short": "y" * 21}).status_code == 422
    assert auth_client.post(f"{BASE}/", json={}).status_code == 422


def test_get_role_with_dots_in_the_path_and_404(auth_client: TestClient) -> None:
    make_role(".1.", "Faina")

    ok = auth_client.get(f"{BASE}/.1.")
    missing = auth_client.get(f"{BASE}/.9.")

    assert ok.status_code == 200 and ok.json()["id"] == ".1."
    assert missing.status_code == 404


def test_listing_filters_and_reports_total(auth_client: TestClient) -> None:
    make_role(".1.", "A", show=True)
    make_role(".2.", "B")
    make_role(".1.1.", "A1", super_roles=".1.")

    shown = auth_client.get(f"{BASE}/", params={"show_only": True}).json()
    children = auth_client.get(f"{BASE}/", params={"parent": ".1."}).json()

    assert [r["id"] for r in shown["items"]] == [".1."]
    assert [r["id"] for r in children["items"]] == [".1.1."]
    assert shown["total"] == 3  # total counts every role, not only the filtered ones


def test_tree_endpoint_nests_roles(auth_client: TestClient) -> None:
    make_role(".1.", "Faina")
    make_role(".1.1.", "CF", super_roles=".1.")

    tree = auth_client.get(f"{BASE}/tree").json()

    assert tree[0]["id"] == ".1." and tree[0]["children"][0]["id"] == ".1.1."


def test_children_endpoint(auth_client: TestClient) -> None:
    make_role(".1.", "Faina")
    make_role(".1.1.", "CF", super_roles=".1.")

    ok = auth_client.get(f"{BASE}/.1./children")
    missing = auth_client.get(f"{BASE}/.9./children")

    assert [r["id"] for r in ok.json()] == [".1.1."]
    assert missing.status_code == 404


def test_update_role(auth_client: TestClient) -> None:
    make_role(".1.", "Old", short="O")

    r = auth_client.put(f"{BASE}/.1.", json={"name": "New", "hidden": True})

    assert r.status_code == 200
    assert (r.json()["name"], r.json()["short"], r.json()["hidden"]) == ("New", "O", True)


def test_update_unknown_role_is_404(auth_client: TestClient) -> None:
    assert auth_client.put(f"{BASE}/.9.", json={"name": "x"}).status_code == 404


def test_update_with_missing_new_parent_is_400_but_empty_parent_is_allowed(
    auth_client: TestClient,
) -> None:
    make_role(".1.", "A")

    bad = auth_client.put(f"{BASE}/.1.", json={"super_roles": ".9."})
    root = auth_client.put(f"{BASE}/.1.", json={"super_roles": ""})

    assert bad.status_code == 400
    assert root.status_code == 200


def test_delete_leaf_role(auth_client: TestClient) -> None:
    make_role(".1.", "A")

    assert auth_client.delete(f"{BASE}/.1.").status_code == 204
    assert auth_client.delete(f"{BASE}/.1.").status_code == 404


def test_cannot_delete_role_with_children(auth_client: TestClient) -> None:
    make_role(".1.", "A")
    make_role(".1.1.", "B", super_roles=".1.")

    r = auth_client.delete(f"{BASE}/.1.")

    assert r.status_code == 400 and "1 child" in r.json()["detail"]
    assert auth_client.get(f"{BASE}/.1.").status_code == 200


@pytest.mark.parametrize(
    "method,path,body",
    [
        ("get", "/", None), ("get", "/tree", None), ("get", "/.1.", None),
        ("get", "/.1./children", None), ("post", "/", {"name": "x"}),
        ("put", "/.1.", {"name": "x"}), ("delete", "/.1.", None),
    ],
)
def test_all_role_endpoints_require_authentication(client: TestClient, method, path, body) -> None:
    assert client.request(method, f"{BASE}{path}", json=body).status_code == 401
