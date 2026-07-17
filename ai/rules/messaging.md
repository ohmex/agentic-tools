# Messaging (Kafka) Rules

- Topic naming: `{domain}.{entity}.{event}` (e.g. `orders.order.created`), lowercase, dot-separated.
- Every event has a versioned schema (`v1`, `v2` in the payload or a schema registry subject) — never change an existing event's shape in place; add a new version instead.
- Every event includes `tenant_id`, `event_id` (UUID), `occurred_at`, and a `trace_id` for correlation with distributed tracing.
- Consumers must be idempotent — process based on `event_id` deduplication, since Kafka guarantees at-least-once delivery, not exactly-once.
- Never assume ordering across partitions unless the producer explicitly partitions by a key that guarantees the ordering you need (e.g. partition by `tenant_id` or aggregate ID).
- Failed messages go to a dead-letter topic (`{original-topic}.dlq`) after a bounded number of retries with backoff — never retry indefinitely inline, and never silently drop.
- Consumers commit offsets only after successful processing (or successful DLQ routing), never before.
- Producers wrap publish failures with context and surface them to the caller or an outbox pattern — never fire-and-forget without error handling.
- Schema changes are backward-compatible (new optional fields only) within a version; breaking changes require a new event version, with both versions published during a migration window.
- See `ai/examples/kafka-consumer.md` for the canonical consumer pattern.
