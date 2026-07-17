# SLAs & Non-Functional Requirements

> Update as targets are formalized or renegotiated with customers. Performance and observability work should be calibrated against these, not arbitrary guesses.

## Availability

| Tier | Uptime target | Notes |
|---|---|---|
| {e.g. Enterprise tenants} | {e.g. 99.9%} | |
| {e.g. Standard tenants} | {e.g. 99.5%} | |

## Latency targets

| Endpoint class | p50 | p95 | p99 | Notes |
|---|---|---|---|---|
| {e.g. read endpoints} | {target} | {target} | {target} | |
| {e.g. write endpoints} | {target} | {target} | {target} | |
| {e.g. bulk/export endpoints} | n/a | n/a | n/a | async, SLA is completion time not latency |

## Data durability & recovery

- **RPO (Recovery Point Objective):** {e.g. 5 minutes} — max acceptable data loss window.
- **RTO (Recovery Time Objective):** {e.g. 1 hour} — max acceptable time to restore service after a major incident.
- Backup frequency and retention: {details}

## Support/incident response targets

| Severity | Response time | Notes |
|---|---|---|
| Sev1 (major outage) | {e.g. 15 min} | pages on-call |
| Sev2 (degraded) | {e.g. 1 hour} | |
| Sev3 (minor) | {e.g. next business day} | |

## Where these are enforced

- Alerts (`ai/rules/observability.md`) should be tuned to catch SLA violations before customers report them.
- Load testing (`ai/rules/performance.md`) validates latency targets before major releases.
