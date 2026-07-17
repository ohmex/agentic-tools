# Security Review Checklist

Use for any change touching authentication, authorization, tenancy boundaries, or data access — deeper than the baseline code-review checklist.

## Authentication & authorization

- [ ] JWT validated for signature, issuer, audience, and expiry — not just presence
- [ ] Every endpoint enforces authorization before business logic executes
- [ ] No endpoint relies on client-supplied `tenant_id`/`user_id` for authorization decisions — derived from validated token claims only

## Tenant isolation

- [ ] Every tenant-scoped query has an explicit `tenant_id` predicate
- [ ] RLS policy exists and is tested for any new tenant-scoped table
- [ ] A test proves tenant A cannot read/write tenant B's data

## Data protection

- [ ] No secrets or PII in logs
- [ ] New PII fields classified and covered by deletion/export tooling (`ai/rules/data-privacy.md`)
- [ ] Data encrypted at rest (where required) and in transit

## Injection & input handling

- [ ] No SQL built via string concatenation
- [ ] All user input validated at the boundary
- [ ] Output encoded appropriately to prevent XSS in any browser-rendered context

## Infrastructure

- [ ] Least-privilege service accounts/managed identities used
- [ ] No new public network exposure without explicit justification
- [ ] Secrets sourced from Key Vault, not hardcoded or plain ConfigMaps

## Dependencies

- [ ] No new high/critical vulnerabilities introduced (`ai/rules/dependency-management.md`)

## Sign-off

Reviewed by: {name} — verdict: approve / approve with follow-ups / blocked
