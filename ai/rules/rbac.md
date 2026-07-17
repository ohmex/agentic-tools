# RBAC & Authorization Rules

- Authorization is deny-by-default: a request is rejected unless an explicit role/permission grant allows it — never structure a check as "allow unless denied."
- Roles are defined per tenant membership (`ai/context/domain-model.md`: `User *---* Role per tenant`) — a user's role in one tenant has no bearing on their access in another; never let a single global role field drive cross-tenant authorization decisions.
- Model permissions as discrete, named capabilities (e.g. `orders:read`, `orders:write`, `billing:manage`) rather than coarse role-name string checks (`if role == "admin"`) scattered through handlers — roles are bundles of permissions, and authorization checks test for the permission, not the role name, so role definitions can change without touching every call site.
- Enforce authorization at a single, consistent point per request — middleware or a dedicated authorization service call — not ad hoc `if` checks duplicated across handlers (see `ai/examples/middleware.md` for where identity is established; the authorization check happens immediately after, before any handler business logic).
- Platform-admin/cross-tenant roles (support staff, internal tooling) are modeled explicitly and separately from tenant roles — never reuse a tenant's "admin" role concept to mean platform-wide admin.
- Any action taken via a platform-admin or impersonation path is audit-logged with who, what tenant, what action, and why (ticket/reason code) — this is a compliance requirement, not optional (`ai/agents/compliance.md`).
- Permission checks fail closed on error — if the authorization check itself errors (e.g. can't reach the permission store), the request is denied, never allowed through as a fallback.
- New roles/permissions are additive and documented in `ai/context/domain-model.md`; removing or renaming an existing permission requires checking every call site that references it, not just the role definition.
- Authorization logic is unit-tested directly (given this role/permission set, is this action allowed?) independent of any specific endpoint — see `ai/examples/test.md` for the table-driven pattern to follow.
