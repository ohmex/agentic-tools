# Architecture Rules

- This is a multi-tenant SaaS platform composed of microservices. Every service owns its own data — no shared database tables across service boundaries.
- Tenant isolation is enforced at the data layer via row-level security (RLS) using `tenant_id`. Never write a query against a tenant-scoped table without a `tenant_id` predicate.
- Services communicate via REST (Echo) for synchronous calls and Kafka for asynchronous/event-driven flows. Do not introduce new synchronous coupling between services without an ADR.
- Each service follows: `handler -> service -> repository` layering.
  - **handler**: HTTP concerns only (binding, validation, status codes). No business logic.
  - **service**: business logic, orchestration, transaction boundaries.
  - **repository**: persistence only. No business logic, no HTTP concerns.
- Cross-service data needs are satisfied via API calls or published events — never direct DB access to another service's schema.
- New services must be registered in the architecture context doc (`ai/context/architecture.md`) with their owned data and public API surface.
- Any change that crosses a service boundary or alters the domain model requires an ADR (`ai/templates/adr.md`).
- Configuration is environment-driven (12-factor). Secrets come from Azure Key Vault, never hardcoded or committed.
