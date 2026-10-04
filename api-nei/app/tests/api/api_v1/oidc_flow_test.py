"""OIDC flow: state cookie, ID-token validation, code exchange and routes.

The identity provider is always faked, so these tests are hermetic and do not
depend on the OIDC_* environment of the machine running them.
"""

import time
from datetime import datetime
from types import SimpleNamespace
from unittest.mock import AsyncMock, MagicMock
from urllib.parse import parse_qs, urlparse

import httpx
import pytest
from authlib.jose import JsonWebKey
from authlib.jose import jwt as jose_jwt
from fastapi import HTTPException, Request, Response
from fastapi.testclient import TestClient
from sqlalchemy.orm import Session

from app.api.api_v1.auth import oidc
from app.core.config import settings
from app.models import User
from app.tests.api.api_v1._utils import auth_data

PREFIX = f"{settings.API_V1_STR}/auth/oidc"
FRONTEND = "https://nei.example"
ISSUER = "https://idp.example/application/o/nei/"
CLIENT_ID = "nei-client"
JWKS_URI = "https://idp.example/jwks"


@pytest.fixture(autouse=True)
def oidc_settings(monkeypatch: pytest.MonkeyPatch) -> None:
    monkeypatch.setattr(settings, "OIDC_ENABLED", True)
    monkeypatch.setattr(settings, "OIDC_REDIRECT_BASE_URL", FRONTEND)
    monkeypatch.setattr(settings, "OIDC_CLIENT_ID", CLIENT_ID)
    monkeypatch.setattr(settings, "OIDC_CLIENT_SECRET", "secret")
    monkeypatch.setattr(settings, "OIDC_VERIFY_SSL", True)


@pytest.fixture
def anyio_backend() -> str:
    return "asyncio"


@pytest.fixture
def idp(monkeypatch: pytest.MonkeyPatch) -> SimpleNamespace:
    """Fake `oauth.authentik` client."""
    meta = {
        "issuer": ISSUER,
        "jwks_uri": JWKS_URI,
        "token_endpoint": "https://idp.example/token",
        "userinfo_endpoint": "https://idp.example/userinfo",
    }
    client = SimpleNamespace(
        load_server_metadata=AsyncMock(return_value=meta),
        create_authorization_url=AsyncMock(
            return_value={"url": "https://idp.example/authorize?x=1", "code_verifier": "ver"}
        ),
    )
    monkeypatch.setattr(oidc.oauth, "authentik", client, raising=False)
    client.meta = meta
    return client


# ------------------------------------------------------------ state cookie


def _request_with_cookie(value: str | None) -> Request:
    headers = []
    if value is not None:
        headers.append((b"cookie", f"{oidc._STATE_COOKIE}={value}".encode()))
    return Request({"type": "http", "headers": headers})


def _signed(payload: dict) -> str:
    return oidc._signer().dumps(payload)


def test_state_cookie_roundtrip_carries_all_fields() -> None:
    response = Response()
    oidc._set_state_cookie(
        response, "st", oidc_nonce="n1", redirect_to="/x", user_id=4, code_verifier="cv"
    )
    cookie = response.headers["set-cookie"]
    value = cookie.split(";")[0].split("=", 1)[1]

    payload = oidc._verify_and_pop_state_cookie(_request_with_cookie(value), Response(), "st")

    assert payload == {"s": "st", "n": "n1", "r": "/x", "u": 4, "v": "cv"}
    assert "HttpOnly" in cookie
    assert "samesite=lax" in cookie.lower()


def test_state_cookie_omits_empty_optional_fields() -> None:
    response = Response()
    oidc._set_state_cookie(response, "st")
    value = response.headers["set-cookie"].split(";")[0].split("=", 1)[1]

    assert oidc._signer().loads(value) == {"s": "st"}


def test_user_id_zero_is_preserved_in_state() -> None:
    response = Response()
    oidc._set_state_cookie(response, "st", user_id=0)
    value = response.headers["set-cookie"].split(";")[0].split("=", 1)[1]

    assert oidc._signer().loads(value)["u"] == 0


def _raises_401(cookie: str | None, state: str = "st") -> str:
    response = Response()
    request = _request_with_cookie(cookie)
    with pytest.raises(HTTPException) as exc:
        oidc._verify_and_pop_state_cookie(request, response, state)
    assert exc.value.status_code == 401
    # The cookie is always cleared, even when verification fails.
    assert oidc._STATE_COOKIE in response.headers["set-cookie"]
    return exc.value.detail


def test_missing_state_cookie_is_rejected() -> None:
    assert _raises_401(None) == "Missing OAuth state cookie"


def test_tampered_state_cookie_is_rejected() -> None:
    assert _raises_401(_signed({"s": "st"}) + "x") == "Invalid OAuth state"


def test_state_cookie_signed_with_other_key_is_rejected() -> None:
    from itsdangerous import URLSafeTimedSerializer

    forged = URLSafeTimedSerializer("not-the-key").dumps({"s": "st"})

    assert _raises_401(forged) == "Invalid OAuth state"


def test_expired_state_cookie_is_rejected(monkeypatch: pytest.MonkeyPatch) -> None:
    cookie = _signed({"s": "st"})
    monkeypatch.setattr(oidc, "_STATE_MAX_AGE", -1)

    assert "expired" in _raises_401(cookie)


def test_state_mismatch_is_rejected() -> None:
    assert _raises_401(_signed({"s": "other"})) == "OAuth state mismatch"


def test_state_missing_in_payload_is_rejected() -> None:
    assert _raises_401(_signed({"r": "/x"})) == "OAuth state mismatch"


def test_legacy_nonce_key_is_still_accepted_as_state() -> None:
    payload = oidc._verify_and_pop_state_cookie(
        _request_with_cookie(_signed({"n": "st"})), Response(), "st"
    )

    assert payload["n"] == "st"


# ------------------------------------------------------ ID-token validation


@pytest.fixture(scope="module")
def signing_key():
    return JsonWebKey.generate_key("RSA", 2048, {"kid": "k1"}, is_private=True)


def _id_token(key, **overrides) -> str:
    now = int(time.time())
    claims = {
        "iss": ISSUER,
        "aud": CLIENT_ID,
        "sub": "sub-1",
        "exp": now + 300,
        "iat": now,
        "nonce": "nonce-1",
    }
    claims.update(overrides)
    claims = {k: v for k, v in claims.items() if v is not None}
    return jose_jwt.encode({"alg": "RS256", "kid": "k1"}, claims, key).decode()


@pytest.fixture
def jwks(monkeypatch: pytest.MonkeyPatch, signing_key) -> AsyncMock:
    mock = AsyncMock(return_value={"keys": [signing_key.as_dict(is_private=False)]})
    monkeypatch.setattr(oidc, "_fetch_jwks", mock)
    return mock


@pytest.mark.anyio
async def test_valid_id_token_passes(idp, jwks, signing_key) -> None:
    await oidc._validate_id_token(
        _id_token(signing_key), expected_nonce="nonce-1", expected_sub="sub-1"
    )

    jwks.assert_awaited_once_with(JWKS_URI)


@pytest.mark.anyio
async def test_nonce_and_sub_checks_are_skipped_when_not_expected(
    idp, jwks, signing_key
) -> None:
    await oidc._validate_id_token(
        _id_token(signing_key, nonce="whatever"), expected_nonce=None, expected_sub=None
    )


@pytest.mark.anyio
@pytest.mark.parametrize(
    "overrides,detail",
    [
        ({"iss": "https://evil.example/"}, "Invalid ID token"),
        ({"aud": "someone-else"}, "Invalid ID token"),
        ({"exp": int(time.time()) - 10}, "Invalid ID token"),
        ({"exp": None}, "Invalid ID token"),
        ({"nonce": "replayed"}, "ID token nonce mismatch"),
        ({"nonce": None}, "ID token nonce mismatch"),
        ({"sub": "another-user"}, "ID token subject mismatch"),
    ],
    ids=["bad-iss", "bad-aud", "expired", "no-exp", "bad-nonce", "no-nonce", "bad-sub"],
)
async def test_invalid_id_token_claims_are_rejected(
    idp, jwks, signing_key, overrides, detail
) -> None:
    token = _id_token(signing_key, **overrides)

    with pytest.raises(HTTPException) as exc:
        await oidc._validate_id_token(
            token, expected_nonce="nonce-1", expected_sub="sub-1"
        )

    assert exc.value.status_code == 401
    assert exc.value.detail == detail


@pytest.mark.anyio
async def test_id_token_signed_by_unknown_key_is_rejected(idp, jwks) -> None:
    attacker = JsonWebKey.generate_key("RSA", 2048, {"kid": "k1"}, is_private=True)

    forged_token = _id_token(attacker)

    with pytest.raises(HTTPException) as exc:
        await oidc._validate_id_token(
            forged_token, expected_nonce="nonce-1", expected_sub="sub-1"
        )

    assert exc.value.detail == "Invalid ID token"


@pytest.mark.anyio
async def test_garbage_id_token_is_rejected(idp, jwks) -> None:
    with pytest.raises(HTTPException) as exc:
        await oidc._validate_id_token("not.a.jwt", expected_nonce=None, expected_sub=None)

    assert exc.value.status_code == 401


# ------------------------------------------------------------ code exchange


class _FakeHttpx:
    """Context-manager stand-in for `httpx.AsyncClient` recording calls."""

    def __init__(self, token_json: dict, userinfo_json: dict, *, fail: str | None = None):
        self.calls: list[tuple] = []
        self.token_json, self.userinfo_json, self.fail = token_json, userinfo_json, fail
        self.ctor_kwargs: dict = {}

    def factory(self, **kwargs):
        self.ctor_kwargs = kwargs
        return self

    async def __aenter__(self):
        return self

    async def __aexit__(self, *exc):
        return False

    def _resp(self, payload: dict, name: str) -> MagicMock:
        resp = MagicMock()
        resp.json.return_value = payload
        if self.fail == name:
            resp.raise_for_status.side_effect = httpx.HTTPStatusError(
                "boom", request=MagicMock(), response=MagicMock()
            )
        return resp

    async def post(self, url, data=None, **kw):
        self.calls.append(("post", url, data))
        return self._resp(self.token_json, "post")

    async def get(self, url, headers=None, params=None, **kw):
        self.calls.append(("get", url, headers or params))
        return self._resp(self.userinfo_json, "get")


@pytest.mark.anyio
async def test_exchange_code_posts_pkce_verifier_and_uses_bearer(monkeypatch) -> None:
    fake = _FakeHttpx({"access_token": "at", "id_token": "idt"}, {"sub": "s"})
    monkeypatch.setattr(oidc.httpx, "AsyncClient", fake.factory)

    userinfo, id_token = await oidc._exchange_code(
        "the-code", "https://api/cb", "https://idp/token", "https://idp/userinfo",
        code_verifier="cv",
    )

    assert (userinfo, id_token) == ({"sub": "s"}, "idt")
    _, url, data = fake.calls[0]
    assert url == "https://idp/token"
    assert data == {
        "grant_type": "authorization_code",
        "code": "the-code",
        "redirect_uri": "https://api/cb",
        "client_id": CLIENT_ID,
        "client_secret": "secret",
        "code_verifier": "cv",
    }
    assert fake.calls[1] == ("get", "https://idp/userinfo", {"Authorization": "Bearer at"})
    assert fake.ctor_kwargs == {"verify": True}


@pytest.mark.anyio
async def test_exchange_code_without_pkce_omits_verifier_and_id_token(monkeypatch) -> None:
    fake = _FakeHttpx({"access_token": "at"}, {"sub": "s"})
    monkeypatch.setattr(oidc.httpx, "AsyncClient", fake.factory)

    _, id_token = await oidc._exchange_code("c", "r", "https://t", "https://u")

    assert id_token is None
    assert "code_verifier" not in fake.calls[0][2]


@pytest.mark.anyio
@pytest.mark.parametrize("failing", ["post", "get"])
async def test_exchange_code_propagates_http_errors(monkeypatch, failing) -> None:
    fake = _FakeHttpx({"access_token": "at"}, {"sub": "s"}, fail=failing)
    monkeypatch.setattr(oidc.httpx, "AsyncClient", fake.factory)

    with pytest.raises(httpx.HTTPStatusError):
        await oidc._exchange_code("c", "r", "https://t", "https://u")


# ------------------------------------------------ Authentik display-name sync


@pytest.mark.anyio
async def test_name_sync_is_skipped_without_token_or_name(monkeypatch) -> None:
    fake = _FakeHttpx({}, {})
    monkeypatch.setattr(oidc.httpx, "AsyncClient", fake.factory)

    monkeypatch.setattr(settings, "AUTHENTIK_TOKEN", None)
    await oidc._sync_authentik_user_name("a@b.c", "Ana Silva")
    monkeypatch.setattr(settings, "AUTHENTIK_TOKEN", "tok")
    await oidc._sync_authentik_user_name("a@b.c", "")

    assert fake.calls == []


@pytest.mark.anyio
async def test_name_sync_patches_when_name_differs(monkeypatch) -> None:
    patched = {}

    class Fake(_FakeHttpx):
        async def patch(self, url, json=None, headers=None):
            patched.update(url=url, json=json)

    fake = Fake({}, {"results": [{"pk": 7, "name": "Old"}]})
    monkeypatch.setattr(oidc.httpx, "AsyncClient", fake.factory)
    monkeypatch.setattr(settings, "AUTHENTIK_TOKEN", "tok")

    await oidc._sync_authentik_user_name("a@b.c", "Ana Silva")

    assert patched["json"] == {"name": "Ana Silva"}
    assert patched["url"].endswith("/api/v3/core/users/7/")
    assert fake.calls[0][0:2] == ("get", f"{settings.AUTHENTIK_URL}/api/v3/core/users/")


@pytest.mark.anyio
@pytest.mark.parametrize(
    "results", [[], [{"pk": 1, "name": "Ana Silva"}]], ids=["no-user", "already-synced"]
)
async def test_name_sync_does_not_patch_when_nothing_to_do(monkeypatch, results) -> None:
    class Fake(_FakeHttpx):
        patch = AsyncMock()

    fake = Fake({}, {"results": results})
    monkeypatch.setattr(oidc.httpx, "AsyncClient", fake.factory)
    monkeypatch.setattr(settings, "AUTHENTIK_TOKEN", "tok")

    await oidc._sync_authentik_user_name("a@b.c", "Ana Silva")

    Fake.patch.assert_not_awaited()


@pytest.mark.anyio
async def test_name_sync_swallows_http_errors(monkeypatch) -> None:
    fake = _FakeHttpx({}, {}, fail="get")
    monkeypatch.setattr(oidc.httpx, "AsyncClient", fake.factory)
    monkeypatch.setattr(settings, "AUTHENTIK_TOKEN", "tok")

    await oidc._sync_authentik_user_name("a@b.c", "Ana Silva")  # must not raise


# ---------------------------------------------------------- helper behaviours


def test_nmec_and_iupi_are_coerced_defensively(db: Session) -> None:
    base = {"sub": "s-coerce", "email": "coerce@test.com", "email_verified": True}

    user = oidc.get_or_create_user_from_oidc(
        db, {**base, "nmec": "12345", "iupi": "x" * 100}
    )

    assert user.nmec == 12345
    assert len(user.iupi) == 36


@pytest.mark.parametrize("raw", [["1"], {"a": 1}, "12a", None, 1.5])
def test_unparseable_nmec_is_discarded(db: Session, raw) -> None:
    user = oidc.get_or_create_user_from_oidc(
        db,
        {"sub": "s-nmec", "email": "nmec@test.com", "email_verified": True, "nmec": raw},
    )

    assert user.nmec is None


def test_login_resyncs_scopes_from_idp(db: Session) -> None:
    info = {"sub": "s-scope", "email": "scope@test.com", "email_verified": True}
    user = oidc.get_or_create_user_from_oidc(db, {**info, "scopes": ["manager-nei"]})
    assert user.scopes == ["manager-nei"]

    again = oidc.get_or_create_user_from_oidc(db, {**info, "scopes": ["default"]})

    assert again.id == user.id
    assert again.scopes == ["default"]


def test_login_with_unchanged_data_does_not_touch_user(db: Session, monkeypatch) -> None:
    info = {
        "sub": "s-same", "email": "same@test.com", "email_verified": True,
        "first_name": "A", "last_name": "B",
    }
    user = oidc.get_or_create_user_from_oidc(db, info)
    commit = MagicMock()
    monkeypatch.setattr(db, "commit", commit)

    oidc.get_or_create_user_from_oidc(db, info)

    commit.assert_not_called()
    assert user.name == "A"


def test_race_that_cannot_be_resolved_reraises(db: Session, monkeypatch) -> None:
    from sqlalchemy.exc import IntegrityError

    monkeypatch.setattr(
        oidc.crud.user, "create", MagicMock(side_effect=IntegrityError("x", {}, Exception()))
    )

    with pytest.raises(IntegrityError):
        oidc.get_or_create_user_from_oidc(
            db, {"sub": "s-race", "email": "race@test.com", "email_verified": True}
        )


# ------------------------------------------------------------------- /login


def _state_cookie_payload(response) -> dict:
    return oidc._signer().loads(response.cookies[oidc._STATE_COOKIE])


@pytest.mark.parametrize("client", [None], indirect=True)
def test_login_redirects_to_idp_with_signed_state_cookie(client: TestClient, idp) -> None:
    r = client.get(f"{PREFIX}/login", params={"redirect_to": "/events"}, follow_redirects=False)

    assert r.status_code == 307
    assert r.headers["location"] == "https://idp.example/authorize?x=1"
    payload = _state_cookie_payload(r)
    assert payload["r"] == "/events"
    assert payload["v"] == "ver"
    assert payload["s"]
    assert payload["n"]
    assert payload["s"] != payload["n"]
    kwargs = idp.create_authorization_url.await_args.kwargs
    assert kwargs["state"] == payload["s"]
    assert kwargs["nonce"] == payload["n"]
    assert idp.create_authorization_url.await_args.args[0].endswith("/auth/oidc/callback")


@pytest.mark.parametrize("client", [None], indirect=True)
@pytest.mark.parametrize("evil", ["//evil.com", "https://evil.com", "/\\evil.com", "evil"])
def test_login_drops_unsafe_redirect_but_still_logs_in(
    client: TestClient, idp, evil: str
) -> None:
    r = client.get(f"{PREFIX}/login", params={"redirect_to": evil}, follow_redirects=False)

    assert r.status_code == 307
    assert "r" not in _state_cookie_payload(r)


@pytest.mark.parametrize("client", [None], indirect=True)
def test_login_when_idp_unreachable_redirects_to_login_error(client: TestClient, idp) -> None:
    idp.load_server_metadata.side_effect = httpx.ConnectError("down")

    r = client.get(f"{PREFIX}/login", follow_redirects=False)

    assert r.status_code == 302
    assert r.headers["location"] == f"{FRONTEND}/auth/login?error=idp_unreachable"
    assert oidc._STATE_COOKIE not in r.cookies


@pytest.mark.parametrize("client", [None], indirect=True)
def test_login_unexpected_failure_redirects_with_unknown_error(client: TestClient, idp) -> None:
    idp.create_authorization_url.side_effect = RuntimeError("bug")

    r = client.get(f"{PREFIX}/login", follow_redirects=False)

    assert r.headers["location"].endswith("error=unknown")


# ---------------------------------------------------------------- /callback


USERINFO = {
    "sub": "sub-cb",
    "email": "callback@test.com",
    "email_verified": True,
    "first_name": "Cal",
    "last_name": "Back",
}


@pytest.fixture
def exchange(monkeypatch: pytest.MonkeyPatch, idp) -> SimpleNamespace:
    ns = SimpleNamespace(
        exchange=AsyncMock(return_value=(dict(USERINFO), "id-token")),
        validate=AsyncMock(),
        sync_name=AsyncMock(),
    )
    monkeypatch.setattr(oidc, "_exchange_code", ns.exchange)
    monkeypatch.setattr(oidc, "_validate_id_token", ns.validate)
    monkeypatch.setattr(oidc, "_sync_authentik_user_name", ns.sync_name)
    return ns


def _callback(client: TestClient, *, payload: dict | None = None, state: str = "st"):
    cookies = {oidc._STATE_COOKIE: _signed(payload or {"s": "st"})}
    return client.get(
        f"{PREFIX}/callback",
        params={"code": "c", "state": state},
        cookies=cookies,
        follow_redirects=False,
    )


@pytest.mark.parametrize("client", [None], indirect=True)
def test_callback_success_creates_user_and_hands_token_in_url_fragment(
    client: TestClient, db: Session, exchange
) -> None:
    r = _callback(client, payload={"s": "st", "n": "nn", "v": "cv", "r": "/events"})

    assert r.status_code == 302
    location = urlparse(r.headers["location"])
    assert f"{location.scheme}://{location.netloc}{location.path}" == f"{FRONTEND}/auth/oidc/return"
    # token is in the fragment (never the query string) and redirect is preserved
    fragment = parse_qs(location.fragment)
    assert fragment["token"][0]
    assert fragment["redirect_to"] == ["/events"]
    assert location.query == ""
    assert "refresh" in r.cookies
    assert db.query(User).filter(User.authentik_sub == "sub-cb").one()
    exchange.exchange.assert_awaited_once()
    assert exchange.exchange.await_args.kwargs == {"code_verifier": "cv"}
    exchange.validate.assert_awaited_once_with(
        "id-token", expected_nonce="nn", expected_sub="sub-cb"
    )
    exchange.sync_name.assert_awaited_once_with("callback@test.com", "Cal Back")


@pytest.mark.parametrize("client", [None], indirect=True)
def test_callback_drops_unsafe_redirect_from_state(client: TestClient, exchange) -> None:
    r = _callback(client, payload={"s": "st", "r": "//evil.com"})

    assert "redirect_to" not in parse_qs(urlparse(r.headers["location"]).fragment)


@pytest.mark.parametrize("client", [None], indirect=True)
def test_callback_skips_name_sync_when_idp_gives_no_name(client: TestClient, exchange) -> None:
    exchange.exchange.return_value = (
        {"sub": "s", "email": "nn@test.com", "email_verified": True, "name": "Only Name"},
        "id-token",
    )

    r = _callback(client)

    assert r.status_code == 302
    exchange.sync_name.assert_not_awaited()


@pytest.mark.parametrize("client", [None], indirect=True)
def test_callback_without_state_cookie_is_401(client: TestClient, exchange) -> None:
    r = client.get(f"{PREFIX}/callback", params={"code": "c", "state": "st"})

    assert r.status_code == 401


@pytest.mark.parametrize("client", [None], indirect=True)
def test_callback_with_wrong_state_is_401_and_never_hits_idp(
    client: TestClient, exchange
) -> None:
    r = _callback(client, state="attacker-state")

    assert r.status_code == 401
    exchange.exchange.assert_not_awaited()


@pytest.mark.parametrize("client", [None], indirect=True)
def test_callback_requires_code_and_state(client: TestClient) -> None:
    assert client.get(f"{PREFIX}/callback").status_code == 422


@pytest.mark.parametrize("client", [None], indirect=True)
def test_callback_disabled_returns_503(client: TestClient, monkeypatch) -> None:
    monkeypatch.setattr(settings, "OIDC_ENABLED", False)

    r = client.get(f"{PREFIX}/callback", params={"code": "c", "state": "s"})

    assert r.status_code == 503


@pytest.mark.parametrize("client", [None], indirect=True)
def test_callback_missing_id_token_redirects_with_session_error(
    client: TestClient, exchange
) -> None:
    exchange.exchange.return_value = (dict(USERINFO), None)

    r = _callback(client)

    assert r.headers["location"] == f"{FRONTEND}/auth/login?error=session"
    exchange.validate.assert_not_awaited()


@pytest.mark.parametrize("client", [None], indirect=True)
def test_callback_invalid_id_token_redirects_with_session_error(
    client: TestClient, exchange
) -> None:
    exchange.validate.side_effect = HTTPException(401, "Invalid ID token")

    assert _callback(client).headers["location"].endswith("error=session")


@pytest.mark.parametrize("client", [None], indirect=True)
def test_callback_unverified_email_is_not_logged_in(
    client: TestClient, db: Session, exchange
) -> None:
    exchange.exchange.return_value = ({**USERINFO, "email_verified": False}, "id-token")

    r = _callback(client)

    assert r.headers["location"].endswith("error=unverified")
    assert "refresh" not in r.cookies
    assert db.query(User).filter(User.authentik_sub == "sub-cb").first() is None


@pytest.mark.parametrize("client", [None], indirect=True)
def test_callback_incomplete_userinfo_redirects_with_invalid_response(
    client: TestClient, exchange
) -> None:
    exchange.exchange.return_value = ({"sub": "x"}, "id-token")

    assert _callback(client).headers["location"].endswith("error=invalid_response")


@pytest.mark.parametrize("client", [None], indirect=True)
def test_callback_idp_http_failure_redirects_as_unreachable(
    client: TestClient, exchange
) -> None:
    exchange.exchange.side_effect = httpx.ConnectError("down")

    assert _callback(client).headers["location"].endswith("error=idp_unreachable")


@pytest.mark.parametrize("client", [None], indirect=True)
def test_callback_unexpected_error_redirects_as_unknown(client: TestClient, exchange) -> None:
    exchange.exchange.side_effect = RuntimeError("bug")

    assert _callback(client).headers["location"].endswith("error=unknown")


@pytest.mark.parametrize("client", [None], indirect=True)
def test_callback_other_http_status_maps_to_unknown(client: TestClient, exchange) -> None:
    exchange.validate.side_effect = HTTPException(418, "teapot")

    assert _callback(client).headers["location"].endswith("error=unknown")


# -------------------------------------------------------------------- /link


def _db_user(db: Session, *, sub: str | None = None) -> User:
    user = User(
        name="Link",
        surname="Me",
        authentik_sub=sub,
        created_at=datetime.fromtimestamp(0),
        updated_at=datetime.fromtimestamp(0),
    )
    db.add(user)
    db.commit()
    return user


def _as(user: User):
    return [auth_data(sub=user.id)]


def test_link_requires_authentication(client: TestClient) -> None:
    assert client.post(f"{PREFIX}/link").status_code == 401


def test_link_start_for_unlinked_user_redirects_with_user_in_state(
    app, client: TestClient, db: Session, idp
) -> None:
    user = _db_user(db)
    app.dependency_overrides[oidc.verify_token] = lambda: auth_data(sub=user.id)

    r = client.post(f"{PREFIX}/link", follow_redirects=False)

    assert r.status_code == 307
    assert r.headers["location"] == "https://idp.example/authorize?x=1"
    assert _state_cookie_payload(r)["u"] == user.id
    assert idp.create_authorization_url.await_args.args[0].endswith("/oidc/link-callback")


def test_link_start_unknown_user_is_404(app, client: TestClient, idp) -> None:
    app.dependency_overrides[oidc.verify_token] = lambda: auth_data(sub=987654321)

    assert client.post(f"{PREFIX}/link").status_code == 404


def test_link_start_already_linked_is_400(app, client: TestClient, db: Session, idp) -> None:
    user = _db_user(db, sub="already")
    app.dependency_overrides[oidc.verify_token] = lambda: auth_data(sub=user.id)

    r = client.post(f"{PREFIX}/link")

    assert r.status_code == 400
    assert r.json()["detail"] == "Account is already linked to Authentik"


def test_link_start_idp_unreachable_is_502(app, client: TestClient, db: Session, idp) -> None:
    user = _db_user(db)
    app.dependency_overrides[oidc.verify_token] = lambda: auth_data(sub=user.id)
    idp.load_server_metadata.side_effect = httpx.ConnectError("down")

    assert client.post(f"{PREFIX}/link").status_code == 502


def test_link_start_disabled_is_503(app, client: TestClient, monkeypatch) -> None:
    monkeypatch.setattr(settings, "OIDC_ENABLED", False)
    app.dependency_overrides[oidc.verify_token] = lambda: auth_data(sub=1)

    assert client.post(f"{PREFIX}/link").status_code == 503


# ------------------------------------------------------------ /link-callback


def _link_callback(client: TestClient, payload: dict | None):
    cookies = {oidc._STATE_COOKIE: _signed(payload)} if payload is not None else {}
    return client.get(
        f"{PREFIX}/link-callback", params={"code": "c", "state": "st"}, cookies=cookies
    )


@pytest.mark.parametrize("client", [None], indirect=True)
def test_link_callback_links_authentik_sub_to_user(
    client: TestClient, db: Session, exchange
) -> None:
    user = _db_user(db)

    r = _link_callback(client, {"s": "st", "u": user.id, "n": "nn", "v": "cv"})

    assert r.status_code == 200
    assert r.json() == {"status": "success", "message": "Account successfully linked to Authentik"}
    db.refresh(user)
    assert user.authentik_sub == "sub-cb"
    assert exchange.exchange.await_args.args[1].endswith("/oidc/link-callback")
    exchange.validate.assert_awaited_once_with(
        "id-token", expected_nonce="nn", expected_sub="sub-cb"
    )


@pytest.mark.parametrize("client", [None], indirect=True)
def test_link_callback_state_without_user_context_is_401(client: TestClient, exchange) -> None:
    r = _link_callback(client, {"s": "st"})

    assert r.status_code == 401
    assert "missing user context" in r.json()["detail"]


@pytest.mark.parametrize("client", [None], indirect=True)
def test_link_callback_without_cookie_is_401(client: TestClient, exchange) -> None:
    assert _link_callback(client, None).status_code == 401


@pytest.mark.parametrize("client", [None], indirect=True)
def test_link_callback_unknown_user_is_404(client: TestClient, exchange) -> None:
    assert _link_callback(client, {"s": "st", "u": 987654321}).status_code == 404


@pytest.mark.parametrize("client", [None], indirect=True)
def test_link_callback_already_linked_user_is_400(
    client: TestClient, db: Session, exchange
) -> None:
    user = _db_user(db, sub="existing")

    r = _link_callback(client, {"s": "st", "u": user.id})

    assert r.status_code == 400
    exchange.exchange.assert_not_awaited()


@pytest.mark.parametrize("client", [None], indirect=True)
def test_link_callback_sub_owned_by_another_user_is_409(
    client: TestClient, db: Session, exchange
) -> None:
    _db_user(db, sub="sub-cb")
    victim = _db_user(db)

    r = _link_callback(client, {"s": "st", "u": victim.id})

    assert r.status_code == 409
    db.refresh(victim)
    assert victim.authentik_sub is None


@pytest.mark.parametrize("client", [None], indirect=True)
def test_link_callback_requires_verified_idp_email(
    client: TestClient, db: Session, exchange
) -> None:
    exchange.exchange.return_value = ({**USERINFO, "email_verified": "false"}, "id-token")
    user = _db_user(db)

    r = _link_callback(client, {"s": "st", "u": user.id})

    assert r.status_code == 403
    db.refresh(user)
    assert user.authentik_sub is None


@pytest.mark.parametrize("client", [None], indirect=True)
def test_link_callback_missing_sub_is_400(client: TestClient, db: Session, exchange) -> None:
    exchange.exchange.return_value = ({"email_verified": True}, "id-token")
    user = _db_user(db)

    assert _link_callback(client, {"s": "st", "u": user.id}).status_code == 400


@pytest.mark.parametrize("client", [None], indirect=True)
def test_link_callback_missing_id_token_is_401(client: TestClient, db: Session, exchange) -> None:
    exchange.exchange.return_value = (dict(USERINFO), None)
    user = _db_user(db)

    assert _link_callback(client, {"s": "st", "u": user.id}).status_code == 401


@pytest.mark.parametrize("client", [None], indirect=True)
def test_link_callback_idp_failure_is_502(client: TestClient, db: Session, exchange) -> None:
    exchange.exchange.side_effect = httpx.ConnectError("down")
    user = _db_user(db)

    assert _link_callback(client, {"s": "st", "u": user.id}).status_code == 502


@pytest.mark.parametrize("client", [None], indirect=True)
def test_link_callback_unexpected_failure_is_500(client: TestClient, db: Session, exchange) -> None:
    exchange.exchange.side_effect = RuntimeError("bug")
    user = _db_user(db)

    r = _link_callback(client, {"s": "st", "u": user.id})

    assert r.status_code == 500
    assert r.json()["detail"] == "Account linking failed"


@pytest.mark.parametrize("client", [None], indirect=True)
def test_link_callback_disabled_is_503(client: TestClient, monkeypatch) -> None:
    monkeypatch.setattr(settings, "OIDC_ENABLED", False)

    assert _link_callback(client, {"s": "st", "u": 1}).status_code == 503
