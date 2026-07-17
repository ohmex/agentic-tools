# API Design Rules

- REST resource naming: plural nouns, kebab-case paths (`/orders`, `/tenant-settings`), no verbs in paths.
- Every endpoint is documented in OpenAPI before or alongside implementation — the spec is the source of truth, not an afterthought.
- Use standard HTTP status codes correctly: `201` on create with `Location` header, `204` on delete, `409` on conflict, `422` on semantic validation failure, `404` only when the resource genuinely doesn't exist (not for permission denial — use `403`).
- All list endpoints support pagination (`page`/`page_size` or cursor-based) — never return unbounded result sets.
- Request/response bodies use `camelCase` JSON field names consistently.
- Breaking changes require a new API version (`/v2/...`); additive changes (new optional fields) do not.
- Every endpoint enforces tenant scoping and authorization before touching data — see `ai/rules/security.md`.
- Errors return a consistent envelope: `{ "error": { "code": "...", "message": "...", "details": [...] } }`.
- Idempotency keys are required on all POST endpoints that create billable or side-effecting resources.
- Validate all input at the handler boundary; the service layer assumes already-validated input.

## OpenAPI-first workflow

- Write or update the OpenAPI spec first for any new/changed endpoint; implementation follows the spec, not the other way around — a handler whose behavior diverges from its documented spec is a bug, not a documentation gap to fix later.
- Lint every spec change with Spectral (or the project's configured linter) in CI — inconsistent naming, missing descriptions, or missing error responses fail the build, not just a review comment.
- Generate server-side types/interfaces (and client SDKs, where consumed by other services) from the OpenAPI spec via codegen — never hand-maintain a duplicate set of request/response structs that can drift from the spec.
- Run contract tests that validate the running service's actual responses against the OpenAPI spec (e.g. schema validation middleware in test mode) — a passing unit test suite does not guarantee spec conformance on its own.
- Host a Swagger UI (or equivalent) per service in non-production environments for manual exploration, generated directly from the committed spec file — never a hand-written, separately maintained API doc page.
- Spec files are versioned alongside the code they describe and reviewed in the same PR as the implementation change — never merged separately or after the fact.
