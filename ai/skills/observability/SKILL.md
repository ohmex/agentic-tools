---
name: observability
description: Logging, metrics, tracing, alerts, and runbook design. Use when adding observability to a new endpoint, job, or service.
---

# Observability Skill

## Responsible for

- Designing what to log, measure, and trace for a new endpoint, job, or service
- Dashboard and alert design that's actually actionable, not noisy
- Writing/maintaining runbooks so an on-call engineer (or `ai/agents/incident-response.md`) can act without reverse-engineering the system under pressure

## Follows

- `ai/rules/observability.md` for the enforced baseline (structured logs, trace propagation, required metrics)

## How to design observability for a new piece of work

1. **Logs**: identify the 2-3 state transitions worth logging at `info` (e.g. "order created", "payment captured") and the failure modes worth `warn`/`error`. Don't log every function entry/exit — that's noise, not signal.
2. **Metrics**: at minimum, request count/latency/error-rate per endpoint or job. Add a custom metric only when a dashboard/alert will actually consume it — a metric nobody looks at is dead weight.
3. **Traces**: confirm the trace ID propagates through every external call the new code makes (DB, HTTP, Kafka) — a trace with a gap at the exact point something got slow is useless for exactly the incident it should help with.
4. **Alerts**: for every new alert, write the threshold *and* the runbook in the same PR (`ai/templates/runbook.md`) — an alert without a runbook just pages someone to guess.
5. **Dashboards**: prefer extending an existing service dashboard over creating a new one per endpoint; a proliferation of near-identical dashboards makes the real signal harder to find during an incident.

## Alert design principles

- Alert on symptoms users would notice (latency, error rate, saturation), not on every internal implementation detail.
- Every alert should be actionable — if the response to an alert is "nothing to do, it'll resolve itself," the threshold is wrong or the alert shouldn't exist.
- Avoid alert fatigue: a flapping alert that's regularly acknowledged-and-ignored erodes trust in every other alert. Fix the threshold or the underlying instability, don't just silence it.

## When reviewing someone else's observability additions

- Missing trace propagation on a new external call is a real gap, not a nitpick — flag it the same way you'd flag a missing test.
- A new endpoint with no corresponding metric is incomplete, per the Definition of Done (`ai/checklists/definition-of-done.md`).
