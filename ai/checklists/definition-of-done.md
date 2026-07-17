# Definition of Done

A change is not done until all applicable items below are checked:

- [ ] OpenAPI spec updated (if API surface changed)
- [ ] Unit tests added/updated for new business logic
- [ ] Integration tests added/updated for repository/DB behavior
- [ ] Playwright tests added/updated for user-facing flows (happy path, validation, permission)
- [ ] Tenant isolation verified (test proving cross-tenant access is denied, where applicable)
- [ ] Migration follows expand/contract pattern, includes RLS policy if new tenant-scoped table
- [ ] Documentation updated (README, glossary, architecture context as needed)
- [ ] Metrics added/updated for new endpoints or jobs
- [ ] Logs are structured, at the right level, and free of secrets/PII
- [ ] Traces propagate through new external calls
- [ ] Security review completed for anything touching auth, tenancy, or data access
- [ ] Linters pass with no suppressed warnings
- [ ] No dead code, commented-out code, or unresolved TODOs without an owner
