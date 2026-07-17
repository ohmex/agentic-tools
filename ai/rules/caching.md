# Caching (Redis) Rules

- Key naming: `{service}:{tenant_id}:{entity}:{id}` — every cache key for tenant-scoped data includes `tenant_id` to prevent cross-tenant leakage through the cache layer.
- Every cache entry has an explicit TTL. No unbounded keys — even "long-lived" config caches get a TTL (hours/days) with a refresh path, not `NX`/never-expiring writes.
- Cache-aside is the default pattern: read cache → miss → read source of truth → populate cache. Write-through/write-behind require an explicit justification (documented in the PR or an ADR).
- Invalidate on write: any mutation to cached data explicitly deletes or updates the corresponding cache key in the same transaction/request path — never rely on TTL alone for correctness-sensitive data.
- Guard against cache stampede on hot keys (e.g. request coalescing, jittered TTLs, or a short-lived lock) for any cache miss that triggers an expensive recompute.
- Never cache data containing secrets or unredacted PII without encryption at rest in Redis and a justified retention period.
- Treat Redis as a cache, not a system of record — any data only in Redis and never persisted elsewhere must be able to be lost without violating correctness (e.g. it's fine for rate-limit counters, not fine for orders).
- Cache client calls have timeouts — a slow/unavailable Redis must degrade to a direct source-of-truth read, not hang the request.

