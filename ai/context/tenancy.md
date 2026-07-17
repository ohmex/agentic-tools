# Multi-Tenancy Model

## Isolation strategy

Row-level isolation: all tenants share database instances/tables, distinguished by a `tenant_id` column, enforced by PostgreSQL Row-Level Security (RLS) policies.

## Enforcement layers (defense in depth)

1. **Database (RLS):** every tenant-scoped table has a policy restricting visibility/writes to the calling session's `tenant_id`. This is the last line of defense and must never be relied upon as the *only* line.
2. **Application (service layer):** every service call receives `tenant_id` from the authenticated JWT claim — never from client-supplied request body/query params — and passes it explicitly through to the repository layer.
3. **API (handler layer):** authorization middleware confirms the authenticated user is a member of the tenant being acted upon before the request reaches business logic.

## Setting tenant context

Document here the actual mechanism used in this codebase (e.g. `SET LOCAL app.tenant_id = $1` per transaction, or a session variable set by a connection-pool middleware). Every repository call must run inside a transaction/connection with tenant context set — never issue a tenant-scoped query without it.

## Testing tenant isolation

Every new tenant-scoped table/endpoint needs a test proving tenant A cannot read or write tenant B's data (`ai/rules/testing.md`).

## Cross-tenant operations

Any legitimate cross-tenant operation (platform admin tooling, billing aggregation) must be explicitly modeled and reviewed — it bypasses the default isolation guarantee and needs its own authorization path, never a shared "superuser" DB role used casually.
