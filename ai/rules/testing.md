# Testing Rules

- Unit tests are mandatory for all new business logic (service layer). No PR merges with declining coverage on touched packages.
- Unit tests must not hit a real database, network, or filesystem — use interfaces and fakes/mocks at the repository boundary.
- Integration tests exercise the repository layer against a real PostgreSQL instance (test container), including RLS policy behavior.

## Testcontainers

- Pin the container image version explicitly (e.g. `postgres:16.4`) — never `:latest` — so integration test behavior doesn't shift under you between runs.
- Start one container per test suite/package (via a shared `TestMain` or suite setup), not one per test case — container startup cost dominates test time if done per-test.
- Run migrations against the container once at suite startup, then isolate each test's data (unique tenant/schema per test, or a transaction rolled back after each test) rather than recreating the container per test.
- Tests using the same suite-level container must be safe to run in parallel — isolate by tenant ID or a per-test schema, never rely on serial execution order for correctness.
- Always tear down containers on both success and failure (`defer`/cleanup hooks) — don't leak containers across CI runs.
- CI must have Docker-in-Docker or an equivalent runner available for testcontainers-based integration tests; if unavailable, fail the pipeline loudly rather than silently skipping integration tests.
- Every new API endpoint needs: a happy-path test, a validation-failure test, an auth/permission-failure test, and a tenant-isolation test (tenant A cannot see tenant B's data).
- Table-driven tests are the default style for Go unit tests.
- Flaky tests are a P1 bug — quarantine and fix within the sprint, do not leave `t.Skip()` indefinitely.
- Playwright covers user-facing flows end-to-end; see `ai/rules/playwright.md`.
- Test names describe behavior, not implementation: `Test_CreateOrder_RejectsWhenTenantOverQuota`, not `Test_CreateOrder_2`.
- Mocks/fakes live next to the interface they implement, generated via `mockery` or hand-written — never duplicate mock definitions.
