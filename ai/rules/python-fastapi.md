# FastAPI Rules

## Layering

- Strict layering, downward-only imports: **Router → Service → Repository → ORM/HTTP client/storage**, mirroring `ai/rules/architecture.md`'s handler → service → repository pattern.
- Routers stay thin (parse/validate input via Pydantic, call one service method, return the response) — no business logic, no direct DB/ORM access in a router.
- Services depend on `typing.Protocol`-typed repository interfaces, not concrete SQLAlchemy `Session` objects — decouples business logic from the persistence implementation and makes it trivially mockable in tests.
- Services raise domain exceptions (`InsufficientFundsError`, not `HTTPException`); routers (or a registered exception handler) translate domain exceptions to the correct HTTP status + the standard error envelope (`ai/rules/api-design.md`). Services never import `fastapi.HTTPException` or `Request`.
- Repositories return domain objects, never leak ORM models or raw driver exceptions past the repository boundary — same expectation as `ai/rules/golang.md`'s repository rule, applied to Python.
- Keep modules under ~400 lines as a soft ceiling; when a file grows past that, split it into a package (`module/__init__.py` + submodules) re-exporting the original names, rather than letting one file become unmanageable.

## External integrations

- Wrap every external API/provider behind an anti-corruption layer: the wrapper returns typed Pydantic models or dataclasses (`GenerateResult`, `ProviderError`), never a raw `dict` from the response JSON — callers should never need to know the wire format of a third-party API.
- Give each external provider its own `httpx.AsyncClient` instance with tailored timeouts and connection limits — never share one client across unrelated providers (a slow/misbehaving provider shouldn't exhaust a pool another provider needs).
- Every side-effecting operation (payments, sends, external creates) accepts an idempotency key to make retries safe.

## Data & API

- Pydantic models serve double duty: request/response validation and serialization — don't hand-write parsing/serialization logic FastAPI + Pydantic already gives you.
- OpenAPI docs are generated automatically from the route/Pydantic definitions — keep them accurate rather than writing a separate hand-maintained doc, per `ai/rules/api-design.md`'s OpenAPI-first workflow.
- SQLAlchemy + Alembic for ORM/migrations, with explicit connection pool sizing (`ai/rules/performance.md`) — never rely on default pool settings for a production service.
- Prefer well-maintained FastAPI ecosystem packages (`fastapi-users`, `fastapi-jwt-auth`, `fastapi-limiter`, `fastapi-pagination`, `fastapi-cache`) over hand-rolled equivalents for auth, rate limiting, pagination, and caching.

## Async, logging, and testing

- Async/await throughout for I/O-bound work (DB, HTTP, LLM calls) — never block the event loop with a synchronous call in an async route.
- Propagate `request_id`/`tenant_id` through async call stacks via `contextvars`, and include them in every structured log line — mirrors `ai/rules/observability.md`'s trace-ID propagation.
- Test with `pytest` + `httpx.AsyncClient` (or `TestClient`) against the real FastAPI app; mock external providers at the anti-corruption-layer boundary, not deep inside a service.
