# Echo Framework Rules

- Register a single custom `HTTPErrorHandler` at the `echo.Echo` instance level that maps domain/service errors to the standard error envelope (`ai/rules/api-design.md`) — handlers should return plain Go errors (via `echo.NewHTTPError` or a wrapped domain error), never write error responses manually with `c.JSON`.
- Middleware order matters and is applied consistently across services: recover → request ID → logging/tracing → CORS (if applicable) → auth (`ai/examples/middleware.md`) → rate limiting → route handler. Don't reorder ad hoc per-route without a documented reason.
- Use `echo.Group` to scope shared middleware (e.g. `/v1` versioning, auth) to a set of routes rather than repeating middleware registration per route.
- Wire request binding and validation through `echo.Validator` (backed by `go-playground/validator` or equivalent) so `c.Bind` + `c.Validate` is the standard two-step in every handler — don't hand-roll validation per handler.
- Handlers never access `c.Request().Context()` more than once to derive the same value — extract tenant/user identity once via the helpers in `ai/examples/middleware.md`.
- Use `e.Server` with explicit `ReadTimeout`/`WriteTimeout`/`IdleTimeout` set — never rely on Echo's defaults for a production listener.
- Shut down gracefully: trap `SIGTERM`/`SIGINT` and call `e.Shutdown(ctx)` with a bounded timeout so in-flight requests complete before the process exits — required for clean Kubernetes rolling updates (`ai/rules/kubernetes.md`).
- Expose `/healthz` (liveness) and `/readyz` (readiness) routes outside any auth middleware group, matching the probes defined in the deployment manifest.
- Don't put business logic in a handler — see the canonical shape in `ai/examples/api.md` and the layering rule in `ai/rules/architecture.md`.
