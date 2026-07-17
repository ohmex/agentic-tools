# Code Review Checklist

## Correctness

- [ ] Logic matches the stated requirement/ticket
- [ ] Edge cases handled (empty input, nil/zero values, concurrent access)
- [ ] Errors are handled or wrapped with context, never swallowed

## Security & tenancy

- [ ] Every tenant-scoped query has a `tenant_id` predicate (defense in depth with RLS)
- [ ] Authorization checked before business logic runs
- [ ] No secrets in code, logs, or config committed to version control
- [ ] No SQL built via string concatenation with user input

## Testing

- [ ] Unit tests cover new business logic
- [ ] Integration tests cover new repository/DB behavior
- [ ] Playwright tests cover new user-facing flows
- [ ] Tests are deterministic (no flaky sleeps/timing assumptions)

## Maintainability

- [ ] No duplicated logic that should reuse an existing pattern (`ai/examples/`)
- [ ] Functions are small and single-purpose
- [ ] Naming is clear and consistent with existing conventions

## Docs & ops

- [ ] OpenAPI spec updated if API surface changed
- [ ] Migration follows expand/contract pattern
- [ ] Metrics/logs/traces present for new code paths
