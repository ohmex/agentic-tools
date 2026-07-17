# Background Jobs Rules

- Every job is idempotent — running it twice with the same input produces the same end state. Use a natural key or dedup token to guard against duplicate execution (job schedulers and queues generally guarantee at-least-once, not exactly-once).
- Every job has a bounded retry policy with backoff and a terminal failure path (dead-letter, alert, or manual-intervention queue) — no infinite retry loops.
- Jobs operating across tenants must iterate explicitly per `tenant_id` and respect the same RLS/authorization boundaries as request-path code — a batch job is not exempt from tenant isolation rules.
- Long-running jobs report progress/heartbeats so stalls are observable (`ai/rules/observability.md`), and are cancellable via context rather than requiring a pod restart to stop.
- Jobs that mutate significant data volumes run in batches with a rate limit, to avoid overwhelming the database or downstream services (see `ai/rules/performance.md`).
- Scheduled jobs (cron) are defined declaratively (Kubernetes `CronJob` or equivalent), version-controlled, and have alerting on missed/failed runs.
- Every job has a documented runbook (`ai/templates/runbook.md`) covering what it does, how to re-run it safely, and how to tell if it's stuck.
