# API Overview

> High-level map of public APIs across services. The authoritative contract for each endpoint lives in its OpenAPI spec — this doc is a navigation aid, not the source of truth.

## Conventions

See `ai/rules/api-design.md` for full conventions (naming, status codes, pagination, error envelope, versioning).

## Service APIs

| Service | Base path | Spec location | Notes |
|---|---|---|---|
| _e.g. tenant-service_ | `/v1/tenants` | `api/tenant-service/openapi.yaml` | |
| _e.g. auth-service_ | `/v1/auth` | `api/auth-service/openapi.yaml` | fronts the OIDC provider |

## Cross-cutting concerns

- **Auth:** all endpoints (except explicitly public ones) require a valid OIDC-issued JWT in `Authorization: Bearer`.
- **Tenant scoping:** tenant ID is derived from the authenticated JWT claim, not from client-supplied input, unless the endpoint is explicitly cross-tenant admin tooling with elevated authorization.
- **Errors:** consistent envelope — see `ai/rules/api-design.md`.
