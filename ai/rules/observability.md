# Observability Rules

- Every service emits structured logs (JSON) with a consistent set of fields: `timestamp`, `level`, `service`, `tenant_id` (when applicable), `trace_id`, `message`.
- Every incoming request gets a trace ID (propagated via OpenTelemetry) that flows through all downstream service and Kafka calls.
- Log at the right level: `debug` for developer detail, `info` for state changes, `warn` for recoverable anomalies, `error` for failures needing attention. Never `error` for expected client-input failures (that's `warn` or below).
- Never log secrets, tokens, passwords, or full PII payloads — redact or omit.
- Every service exposes Prometheus metrics: request count, latency histogram, and error rate per endpoint, at minimum.
- Every new endpoint or background job must have a corresponding dashboard panel or be added to an existing one — no unmonitored code paths.
- Alerts are actionable: every alert links to a runbook explaining what to check and how to remediate.
- Use distributed tracing spans around external calls (DB, HTTP, Kafka) so latency can be attributed correctly.

