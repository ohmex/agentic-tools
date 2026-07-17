# Domain Model

> Update this when core entities or their relationships change. This is the shared vocabulary for design and code.

## Core entities

- **Tenant** — the top-level customer organization. All tenant-scoped data references it via `tenant_id`.
- **User** — an individual identity, authenticated via OIDC, belonging to one or more tenants with a role.
- **Role / Permission** — RBAC model governing what a user may do within a tenant.

> Extend this list as the platform's actual domain entities are defined (e.g. Orders, Subscriptions, Invoices, Workspaces).

## Relationships

```
Tenant 1---* User (via membership)
User   *---* Role (per tenant)
```

## Invariants

- A `User` cannot access data belonging to a `Tenant` they are not a member of.
- Every tenant-scoped entity is deleted (or soft-deleted) when its owning `Tenant` is deleted — define and document the retention/cascade policy per entity.

## Where this is enforced

- Application layer: authorization middleware checks tenant membership and role.
- Database layer: RLS policies keyed on `tenant_id` (see `ai/rules/postgres.md`, `ai/context/tenancy.md`).
