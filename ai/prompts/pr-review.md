# Prompt: PR Review

1. Read the PR description and linked ticket/ADR first — understand intent before reading the diff.
2. Walk the diff file by file, in dependency order (schema/migrations → repository → service → handler → tests → docs).
3. Apply `ai/rules/code-review.md` priority order: correctness → security/tenancy → maintainability → style.
4. Use `ai/checklists/code-review.md` as the baseline checklist.
5. For every finding, cite the file and line, explain the concrete failure scenario (not just "this could be better"), and rate severity (blocking / should-fix / nit).
6. Check test coverage matches the risk of the change — new business logic without tests is a blocking finding.
7. Verify OpenAPI docs were updated if the API surface changed.
8. Summarize with a clear verdict: approve, approve with comments, or request changes — and why.
