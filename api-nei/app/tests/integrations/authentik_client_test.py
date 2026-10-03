"""Authentik admin client: pagination, user lookup, membership and error mapping."""

import asyncio
import json

import httpx
import pytest

from app.core.config import settings
from app.integrations.authentik import AuthentikClient, AuthentikError

BASE = "https://ak.example"


@pytest.fixture(autouse=True)
def configured(monkeypatch: pytest.MonkeyPatch) -> None:
    monkeypatch.setattr(settings, "AUTHENTIK_TOKEN", "secret")
    monkeypatch.setattr(settings, "AUTHENTIK_URL", BASE)


def _client(handler) -> AuthentikClient:
    return AuthentikClient(httpx.MockTransport(handler))


def _run(coro):
    return asyncio.run(coro)


def _error_of(coro) -> AuthentikError:
    with pytest.raises(AuthentikError) as exc:
        _run(coro)
    return exc.value


# ---------------------------------------------------------------- pagination


def test_list_groups_follows_pagination_and_only_sends_params_on_first_page() -> None:
    seen: list[httpx.URL] = []

    def handler(request: httpx.Request) -> httpx.Response:
        seen.append(request.url)
        if request.url.params.get("page") == "2":
            return httpx.Response(
                200,
                json={"results": [{"pk": "2", "name": "B", "users_obj": []}], "pagination": {}},
            )
        return httpx.Response(
            200,
            json={
                "results": [{"pk": "1", "name": "A", "users_obj": [{"uid": "u1"}, {"uid": "u2"}]}],
                "pagination": {"next": f"{BASE}/api/v3/core/groups/?page=2"},
            },
        )

    groups = _run(_client(handler).list_groups())

    assert groups == [
        {"pk": "1", "name": "A", "member_subs": ["u1", "u2"]},
        {"pk": "2", "name": "B", "member_subs": []},
    ]
    assert seen[0].params["include_users"] == "true"
    assert seen[0].params["page_size"] == "100"
    assert "include_users" not in seen[1].params  # `next` already carries its own query


def test_group_without_users_obj_has_no_members() -> None:
    client = _client(
        lambda _: httpx.Response(200, json={"results": [{"pk": "1", "name": "A"}]})
    )

    assert _run(client.list_groups()) == [{"pk": "1", "name": "A", "member_subs": []}]


# ----------------------------------------------------------------- find user


def test_find_user_pk_queries_by_uuid_and_returns_int() -> None:
    def handler(request: httpx.Request) -> httpx.Response:
        assert request.url.params["uuid"] == "sub-1"
        assert request.headers["Authorization"] == "Bearer secret"
        return httpx.Response(200, json={"results": [{"pk": "42"}]})

    assert _run(_client(handler).find_user_pk("sub-1")) == 42


def test_find_user_pk_without_match_is_404() -> None:
    client = _client(lambda _: httpx.Response(200, json={"results": []}))

    error = _error_of(client.find_user_pk("nobody"))

    assert (error.status_code, error.public_detail) == (404, "Authentik user not found")


@pytest.mark.parametrize(
    "results", [[{}], [{"pk": None}], [{"pk": "abc"}]], ids=["no-pk", "null-pk", "non-numeric"]
)
def test_find_user_pk_with_malformed_pk_is_bad_gateway(results) -> None:
    client = _client(lambda _: httpx.Response(200, json={"results": results}))

    assert _error_of(client.find_user_pk("x")).status_code == 502


# ---------------------------------------------------------------- membership


@pytest.mark.parametrize("add,action", [(True, "add_user"), (False, "remove_user")])
def test_set_group_membership_posts_to_the_matching_action(add: bool, action: str) -> None:
    captured = {}

    def handler(request: httpx.Request) -> httpx.Response:
        captured.update(
            method=request.method, path=request.url.path, body=json.loads(request.content)
        )
        return httpx.Response(204)

    _run(_client(handler).set_group_membership("g-1", 42, add=add))

    assert captured == {
        "method": "POST",
        "path": f"/api/v3/core/groups/g-1/{action}/",
        "body": {"pk": 42},
    }


# ---------------------------------------------------------- error translation


def test_not_found_is_translated() -> None:
    client = _client(lambda _: httpx.Response(404))

    error = _error_of(client.get_group_name("missing"))

    assert (error.status_code, error.public_detail) == (404, "Authentik object not found")


@pytest.mark.parametrize("status", [400, 401, 403, 409])
def test_client_errors_are_reported_as_rejected_without_leaking_upstream(status: int) -> None:
    client = _client(lambda _: httpx.Response(status, text="internal secret detail"))

    error = _error_of(client.get_group_name("g"))

    assert (error.status_code, error.public_detail) == (502, "Authentik rejected the request")


def test_network_failure_is_bad_gateway() -> None:
    def handler(request: httpx.Request) -> httpx.Response:
        raise httpx.ConnectError("refused", request=request)

    error = _error_of(_client(handler).get_group_name("g"))

    assert (error.status_code, error.public_detail) == (502, "Authentik is unavailable")


@pytest.mark.parametrize("body", [[1, 2], "text"], ids=["list", "string"])
def test_non_object_json_is_bad_gateway(body) -> None:
    client = _client(lambda _: httpx.Response(200, json=body))

    assert _error_of(client.get_group_name("g")).status_code == 502


# ----------------------------------------------------------------- lifecycle


def test_close_releases_client_and_is_safe_to_repeat() -> None:
    async def scenario() -> None:
        client = _client(lambda _: httpx.Response(200, json={"name": "G"}))
        assert await client.get_group_name("g") == "G"
        assert client._client is not None

        await client.close()
        await client.close()

        assert client._client is None
        # the client lazily rebuilds itself after being closed
        assert await client.get_group_name("g") == "G"
        await client.close()

    _run(scenario())


def test_start_is_idempotent() -> None:
    client = _client(lambda _: httpx.Response(200))

    client.start()
    first = client._client
    client.start()

    assert client._client is first
