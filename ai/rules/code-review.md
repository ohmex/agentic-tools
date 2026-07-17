# Code Review Rules

- Review for correctness first, then security, then maintainability, then style — in that priority order.
- Flag any tenant-isolation gap as a blocking issue, not a suggestion.
- Flag missing tests for new business logic as blocking.
- Flag unhandled/swallowed errors as blocking.
- Style nits (formatting, naming) should be auto-fixed by linters, not raised in review — if a linter should catch it but doesn't, propose a linter rule change instead of a one-off comment.
- Look for duplicated logic that should reuse an existing pattern from `ai/examples/`.
- Check that migrations follow the expand/contract pattern (`ai/rules/migrations.md`).
- Check that API changes are reflected in OpenAPI docs.
- Use `ai/checklists/code-review.md` as the baseline checklist for every review.
- When acting as reviewer, follow `ai/agents/reviewer.md` and report findings ranked by severity, most severe first, with concrete file/line references.
- Rate every finding as **blocker** (must fix before merge), **important** (should fix, can follow up), or **nit** (style/preference, non-blocking) — vague concerns without a rating don't count as findings.
- Review across four angles: **security** (authz gaps, injection, secrets, PII exposure), **performance** (N+1 queries, unbounded work, hot-path allocations, missed concurrency), **tests** (coverage of new paths, assertion strength — read the assertions, not just the test name), and **architecture** (layer boundaries, premature abstraction, coupling, naming that reflects purpose not implementation).
- If the diff is missing surrounding context needed to judge correctness, ask for the full file rather than guessing.
- End every review with an explicit verdict: **safe to merge**, **needs changes**, or **reject**.
