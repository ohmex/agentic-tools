# Node.js Rules

- Use `async`/`await` throughout; never mix callback-style APIs with promise-based code in the same module without a clear reason.
- Use ES modules (`import`/`export`), matching `ai/rules/typescript.md` — no `require`/`module.exports` in new code.
- Trap `SIGTERM`/`SIGINT` and shut down gracefully (close DB pools, finish in-flight requests) — required for clean Kubernetes rolling updates, same as `ai/rules/echo.md`'s Go equivalent.
- Configuration comes from environment variables (`ai/rules/config-management.md`) — validate required config at startup and fail fast, don't discover a missing variable mid-request.
- Structured JSON logging with the same field set as the rest of the platform (`ai/rules/observability.md`) — don't let a Node service's logs be the one inconsistent format in the stack.
- Tune database/HTTP client connection pooling explicitly — don't run with a driver's default pool size in production without checking it matches expected concurrency.
- Cache read-heavy, rarely-changing data with an explicit invalidation strategy, matching `ai/rules/caching.md` — no unbounded in-memory caches in a multi-instance deployment.
- Never commit secrets or `.env` files — pull them from Azure Key Vault, same as every other service (`ai/rules/security.md`).

## If using Express

- Organize middleware explicitly and in a documented order (parsers → security headers/CORS → auth → rate limiting → routes → error handler) — don't scatter `app.use()` calls without a clear sequence.
- Structure routes by domain/feature (`routes/orders`, `routes/billing`), not by HTTP verb or technical layer.
- Validate request bodies/params before the route handler runs (a validation middleware or schema check), mirroring `ai/rules/api-design.md` — handlers assume already-validated input.
- Register a single centralized error-handling middleware that maps thrown/domain errors to the standard error envelope (`ai/rules/api-design.md`) — don't handle errors ad hoc per-route.
- Version the API in the route prefix (`/v1/...`) and keep response shapes consistent across endpoints, same as any other service in this platform.
