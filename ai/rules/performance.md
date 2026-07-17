# Performance Rules

- Measure before optimizing — no speculative optimization without a profile, benchmark, or `EXPLAIN ANALYZE` showing the problem.
- Avoid N+1 queries; batch or join instead.
- Cache read-heavy, rarely-changing data (e.g. tenant config) with a clear invalidation strategy — never cache without an expiry or invalidation path.
- Use pagination/streaming for any endpoint or job that could return unbounded data.
- Prefer connection pooling (pgxpool or equivalent) with sane min/max sizes tuned to expected concurrency, not defaults left unexamined.
- Avoid synchronous cross-service calls in hot paths; prefer async/event-driven where latency isn't user-blocking.
- Set timeouts on every outbound call (HTTP, DB, Kafka) — no call without a bounded worst case.
- Load test any endpoint expected to handle significant traffic before it ships; document the results.
- Watch for goroutine leaks and unbounded queues/channels under load.

