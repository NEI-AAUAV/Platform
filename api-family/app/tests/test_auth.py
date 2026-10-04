"""JWT verification and scope enforcement with real ES512 signatures."""

import time

import pytest
from cryptography.hazmat.primitives import serialization
from cryptography.hazmat.primitives.asymmetric import ec
from fastapi import FastAPI, Security
from fastapi.testclient import TestClient
from jose import jwt

from app.api import auth
from app.core.config import settings


def _keypair() -> tuple[str, str]:
    key = ec.generate_private_key(ec.SECP521R1())
    private = key.private_bytes(
        serialization.Encoding.PEM,
        serialization.PrivateFormat.PKCS8,
        serialization.NoEncryption(),
    ).decode()
    public = key.public_key().public_bytes(
        serialization.Encoding.PEM, serialization.PublicFormat.SubjectPublicKeyInfo
    ).decode()
    return private, public


@pytest.fixture(scope="module")
def keys() -> tuple[str, str]:
    return _keypair()


@pytest.fixture
def client(keys, monkeypatch) -> TestClient:
    monkeypatch.setattr(auth, "public_key", keys[1])
    app = FastAPI()

    @app.get("/any")
    def any_user(payload=Security(auth.verify_scopes)):
        return payload

    @app.get("/family")
    def family(_=Security(auth.verify_scopes, scopes=[auth.ScopeEnum.MANAGER_FAMILY])):
        return {"ok": True}

    @app.get("/both")
    def both(
        _=Security(
            auth.verify_scopes,
            scopes=[auth.ScopeEnum.MANAGER_FAMILY, auth.ScopeEnum.MANAGER_NEI],
        ),
    ):
        return {"ok": True}

    return TestClient(app)


def _token(keys, scopes=None, *, exp_in=300, private=None) -> str:
    claims = {"sub": "1", "exp": int(time.time()) + exp_in}
    if scopes is not None:
        claims["scopes"] = scopes
    return jwt.encode(claims, private or keys[0], algorithm=settings.JWT_ALGORITHM)


def _get(client, path, token=None):
    headers = {"Authorization": f"Bearer {token}"} if token else {}
    return client.get(path, headers=headers)


def test_valid_token_with_required_scope_is_accepted(client, keys) -> None:
    r = _get(client, "/family", _token(keys, ["manager-family"]))

    assert r.status_code == 200


def test_payload_is_handed_to_the_endpoint(client, keys) -> None:
    r = _get(client, "/any", _token(keys, ["default"]))

    assert r.json()["scopes"] == ["default"]
    assert r.json()["sub"] == "1"


def test_endpoint_without_required_scopes_accepts_any_valid_token(client, keys) -> None:
    assert _get(client, "/any", _token(keys)).status_code == 200


def test_missing_token_is_401(client) -> None:
    r = _get(client, "/family")

    assert r.status_code == 401


def test_token_without_the_scope_is_401_with_challenge(client, keys) -> None:
    r = _get(client, "/family", _token(keys, ["default"]))

    assert r.status_code == 401
    assert r.json()["detail"] == "Not enough permissions"
    assert 'scope="manager-family"' in r.headers["www-authenticate"]


def test_token_without_any_scopes_claim_is_rejected(client, keys) -> None:
    assert _get(client, "/family", _token(keys)).status_code == 401


def test_every_required_scope_is_needed(client, keys) -> None:
    only_one = _get(client, "/both", _token(keys, ["manager-family"]))
    both = _get(client, "/both", _token(keys, ["manager-family", "manager-nei"]))

    assert only_one.status_code == 401
    assert both.status_code == 200


def test_admin_bypasses_scope_checks(client, keys) -> None:
    assert _get(client, "/both", _token(keys, ["admin"])).status_code == 200


def test_expired_token_is_rejected(client, keys) -> None:
    r = _get(client, "/family", _token(keys, ["manager-family"], exp_in=-60))

    assert r.status_code == 401
    assert r.json()["detail"] == "Could not validate credentials"


def test_token_signed_with_another_key_is_rejected(client, keys) -> None:
    other_private, _ = _keypair()

    r = _get(client, "/family", _token(keys, ["admin"], private=other_private))

    assert r.status_code == 401


def test_garbage_token_is_rejected(client) -> None:
    assert _get(client, "/family", "not-a-jwt").status_code == 401


def test_token_with_a_different_algorithm_is_rejected(client, keys) -> None:
    forged = jwt.encode({"sub": "1", "scopes": ["admin"]}, "secret", algorithm="HS256")

    assert _get(client, "/family", forged).status_code == 401


def test_challenge_without_scopes_is_plain_bearer(client) -> None:
    r = _get(client, "/any", "bad")

    assert r.headers["www-authenticate"] == "Bearer"
