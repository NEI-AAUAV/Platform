# NEI Platform Authentication Guide

This guide explains how authentication works across the platform: what Authentik is responsible for, what the platform is responsible for, and which knobs actually change behaviour.

## Overview

**Authentik is the authentication authority. The platform is the session authority.**

Authentik proves *who a user is* — once, at login — and supplies *what they are allowed to do* via claims. The platform then mints its own session and Authentik steps out of the loop until the next login.

Concretely, the OIDC callback exchanges the authorization code, calls `/userinfo` once, validates the ID token, and then **discards every Authentik token**. No Authentik `access_token` or `refresh_token` is stored or reused. Everything after login runs on platform-issued ES512 JWTs backed by the `device_login` table.

This is a deliberate design, not an oversight. `api-family`, `api-tacaua`, and the gala extension all verify the platform JWT with a shared public key, which keeps them trivially simple and free of any runtime dependency on Authentik. An Authentik outage blocks new logins; it does not log anyone out or break the API.

## The two token types

| | Platform access token | Platform refresh token |
|---|---|---|
| Format | ES512 JWT, signed with the platform key | ES512 JWT, same key |
| Lifetime | `ACCESS_TOKEN_EXPIRE` — **1 hour** | `REFRESH_TOKEN_EXPIRE` — **24 hours** |
| Storage | In memory (zustand store) — never `localStorage` | HttpOnly cookie, `SameSite=Strict`, path-scoped to `/api/nei/v1/auth` |
| Carries | `sub`, `nmec`, `email`, `image`, `name`, `surname`, `scopes` | `sub`, `sid`, `jti` |
| Revocable | No — valid until it expires | Yes — delete the `device_login` row |

Both lifetimes are defined in [`api-nei/app/core/config.py`](api-nei/app/core/config.py). **Neither comes from Authentik.**

The session is **absolute, not sliding**: `expires_at` is set once when the session is created and is never extended by a refresh. A user is sent back through Authentik 24 hours after login regardless of activity.

## Login flow

1. Frontend navigates to `GET /api/nei/v1/auth/oidc/login` (a full-page redirect — the SPA never talks to Authentik directly).
2. Backend builds the authorization URL from Authentik's discovery document and redirects, with PKCE (S256), `state`, and `nonce`. State and PKCE verifier live in a signed, HttpOnly, 10-minute cookie.
3. User authenticates with Authentik; Authentik redirects back to `/auth/oidc/callback`.
4. Backend verifies `state`, exchanges the code, calls `/userinfo`, and fully validates the ID token — signature against JWKS, plus `iss`, `aud`, `exp`, `nonce`, and a `sub` cross-check against the userinfo response.
5. `get_or_create_user_from_oidc` upserts the user and **re-reads scopes from Authentik claims on every login**.
6. Backend mints the platform token pair and redirects to `/auth/oidc/return#token=...`, with the refresh cookie attached.
7. Frontend reads the token from the URL **fragment** (never the query string — fragments are not sent to servers, logged, or leaked via `Referer`), stores it in memory, and clears it from history.

## Session renewal

The frontend never checks expiry proactively. It is entirely reactive:

- On app mount, and on any `401`, it POSTs to `/api/nei/v1/auth/refresh` with the cookie.
- The backend validates the refresh token, rotates it, and returns a fresh 1-hour access token.
- The original request is replayed transparently. Concurrent 401s are de-duplicated so only one refresh fires.

**Authentik is not involved in this.** Users do not re-authenticate when their access token expires — only when the 24-hour session ends, or when the session is revoked.

### Rotation and replay detection

Every refresh mints a new refresh token carrying a fresh 256-bit `jti`, which is stored on the `device_login` row. A token whose `jti` does not match the stored value is a replay: the request is rejected **and the entire session is deleted**. The row is read with `FOR UPDATE`, so two concurrent refreshes cannot both succeed and fork the session.

Sessions created before the `jti` migration have a `NULL` value and fall back to an older timestamp comparison for exactly one rotation, then self-heal. Once all such rows have aged out (≤ 24h), `refresh_jti` should be made `NOT NULL` and the fallback branch in `_validate_refresh_token` deleted.

## Which Authentik settings actually matter

This is the part that most often causes confusion. Under the OAuth2/OIDC provider config:

| Setting | Effect on the platform |
|---|---|
| **Access Code Validity** | ✅ **Real.** The window to exchange the code — one redirect plus one server-to-server call. Keep it at ~1 minute; that is already ~60× what is needed. |
| **Access Token Validity** | ⚠️ **Effectively none.** The token is consumed by a single `/userinfo` call microseconds after issuance and then discarded. Raising it gains nothing. |
| **Refresh Token Validity** | ❌ **None.** No refresh token is issued (`offline_access` is not requested) and no code path would read one. |
| **Refresh Token Threshold** | ❌ **None.** Same reason. |

**To change how long a session lasts, edit `ACCESS_TOKEN_EXPIRE` / `REFRESH_TOKEN_EXPIRE` — not Authentik.** Both are pydantic `timedelta` settings and can be overridden by environment variable using **ISO-8601 duration** format:

```bash
ACCESS_TOKEN_EXPIRE=PT30M     # 30 minutes
REFRESH_TOKEN_EXPIRE=PT12H    # 12 hours
```

Plain seconds (`1800`) will **not** parse and will crash the container at startup.

### The Authentik setting that does matter

Whether the 24-hour re-login is a silent redirect or a real credential prompt depends on **Authentik's own SSO session duration**, configured in the brand/flow settings — *not* in the OAuth provider. If the session cap ever feels disruptive to users, that is the dial to look at.

## Do not enable `offline_access`

There is no code path that could consume an Authentik refresh token. Enabling the scope would make Authentik mint and persist long-lived refresh tokens on every login that the platform immediately throws away — attack surface with no benefit.

It would only make sense as part of a deliberate migration to a different architecture (see below).

## Configuration reference

| Variable | Purpose | Notes |
|---|---|---|
| `OIDC_ENABLED` | Feature flag | Endpoints return 503 when false |
| `OIDC_CLIENT_ID` / `OIDC_CLIENT_SECRET` | Provider credentials | |
| `OIDC_DISCOVERY_URL` | Discovery document | Defaults to the production Authentik |
| `OIDC_REDIRECT_BASE_URL` | Callback base | Defaults to `HOST` |
| `OIDC_SCOPES` | Requested scopes | `openid profile email nei_scopes nei_nmec nei_iupi` — **no `offline_access`** |
| `OIDC_VERIFY_SSL` | TLS verification for all Authentik calls | Defaults to `true`. Set `false` **only** for a local self-signed Authentik |
| `AUTHENTIK_URL` / `AUTHENTIK_TOKEN` | Admin API credentials | Required for admin role management and display-name sync; those endpoints return 503 without the token |
| `JWT_SECRET_KEY_PATH` / `JWT_PUBLIC_KEY_PATH` | Platform signing keys | The public key is what downstream services verify against |

## Scopes

Scopes are resolved from Authentik claims on **every** login, so Authentik remains the authorization source of truth:

1. The `scopes` claim is checked first (set via the `nei_scopes` property mapping).
2. Falls back to `groups`, stripping an optional `nei-` prefix.
3. Unrecognised values are logged and skipped; an empty result becomes `["default"]`.

Changes made directly in the platform database propagate on the next refresh (≤ 1 hour), because `/auth/refresh` re-reads the user. Changes made **in Authentik** only apply at the next login.

## Known gaps

- **Deprovisioning latency is up to 24 hours.** Disabling a user in Authentik does not end their existing platform session. This is the inherent cost of not using the IdP's tokens. The intended fix is a background reconciliation job sweeping `device_login` against Authentik's admin API — Ofelia already runs a nightly `cleanup-logins.sql` against this table, so it is a sibling job, not new infrastructure. It must **not** live in the `/auth/refresh` path, which would couple every session renewal to Authentik's availability.
- **Access tokens cannot be revoked** before their 1-hour expiry. Validation is signature-only; there is no denylist.
- **Password login still exists** (`/auth/login`) and issues identical sessions, bypassing Authentik's MFA and policies. It is not usable by OIDC-created accounts — they have a `NULL` password hash — but it remains available to any legacy account that still has one. Retiring it completes the migration.

## When to reconsider this architecture

The current model is the right trade for a set of first-party services. Revisit it if any of these become true:

- Third-party or non-first-party API clients need access.
- A mobile app is added.
- Sub-minute revocation becomes a hard requirement.

In that case the alternative is to make Authentik's access token the API credential — services become resource servers validating via JWKS, and refresh tokens are held server-side (where `offline_access` would finally be meaningful). The cost is a hard runtime dependency on Authentik in every service, re-modelling scopes as Authentik property mappings, and rewriting the session layer. Do not do it piecemeal.

## Directus SSO

Directus is a content-admin UI for staff. It lives in the **Infrastructure** repository (`services/directus`), not in this monorepo, and connects directly to `db_pg`. Unlike api-nei, **Directus keeps Authentik's own tokens** — it validates OIDC sessions itself rather than minting platform JWTs, since it is not one of the first-party services covered by the model above.

- **Login is Authentik-only** (`AUTH_DISABLE_DEFAULT=true`) — there is no local email/password form. A break-glass admin account exists for recovery if Authentik is unreachable; see Infrastructure's `services/directus/README.md` "Break-glass recovery".
- **Dedicated Authentik application/client** — do not reuse the `nei-platform` OIDC client used by api-nei. A separate application (slug `nei-directus`) has its own client id/secret.
- Redirect URI: `<DIRECTUS_PUBLIC_URL>auth/login/authentik/callback`.
- Scopes: `openid profile email` — Directus has no use for `nei_scopes`/`nei_nmec`/`nei_iupi`.
- **Onboarding (deliberately manual, fail-safe):** Directus public registration stays **off**. Access is granted by listing a person's email in Infrastructure's `CMS_EDITOR_EMAILS` / `CMS_MANAGER_EMAILS`; provisioning creates the Directus user with the matching fixed-ID role, and their first Authentik login links to it. Authentik must additionally restrict the `nei-directus` application to the staff group. Auto-provisioning on first login (`AUTH_AUTHENTIK_ALLOW_PUBLIC_REGISTRATION=true`) is supported but is only safe once that Authentik binding is verified, so it is not the default. Config lives in Infrastructure's `services/directus/.env`.

### Ownership boundary (Platform vs Infrastructure)

| Owner | Owns |
|---|---|
| **Platform / api-nei** | Every `nei.*` table, column, key, constraint, index and data migration — exclusively through `api-nei/alembic/`. Alembic contains **no** Directus role, schema or grant logic. |
| **Infrastructure** | The Directus deployment, the `directus_svc` login role, the `directus` schema, the table grants Directus needs on `nei.*` (`managed-tables.txt`), and all Directus metadata/roles/policies/permissions/extensions. |

Deployment order: (1) Platform runs `alembic upgrade head` (the `api_nei_migrate` one-shot in `compose.prod.yml`, which api-nei waits for) and starts api-nei; (2) Infrastructure verifies the Platform schema is new enough (it fails with a clear message otherwise — it never runs api-nei migrations), provisions the role/schema/grants, starts Directus and reconciles its metadata. Directus stores asset UUIDs in plain `*_asset` UUID columns; there are no foreign keys from `nei.*` to `directus.*`.

Historic Alembic revisions `d3c7f0a1b2e4`, `f2b4d8e1a9c3`, `e8f0a2b4c6d8`, `f9a1b3c5d7e9` and `b5c7d9e1f3a5` were Directus-infrastructure changes; they are intentionally no-ops now (kept only so the revision graph stays linear).
