# Incident Response Checklist

## During the incident

- [ ] Severity assessed and declared (Sev1/2/3, `ai/context/slas.md`)
- [ ] Blast radius established: which tenants/services/endpoints affected
- [ ] On-call/relevant owners paged if beyond Sev3
- [ ] Status communicated to stakeholders at agreed intervals
- [ ] Runbook checked (`ai/templates/runbook.md`) before improvising a fix
- [ ] Mitigation applied (rollback / flag off / traffic shift / scale) — prefer fastest safe option over root-cause fix under pressure
- [ ] Tenant-isolation integrity confirmed unaffected (or escalated as a security incident if violated)

## Immediately after mitigation

- [ ] Timeline captured while memory is fresh
- [ ] Incident marked resolved, downtime/impact window recorded
- [ ] Postmortem created (`ai/templates/incident-postmortem.md`) with an owner and due date

## Postmortem follow-through

- [ ] Root cause identified and documented (not just symptoms)
- [ ] Action items have owners and tickets
- [ ] Runbook updated or created based on what was learned
- [ ] Postmortem reviewed with the team, not just filed away
- [ ] Action items tracked to completion, not just listed
