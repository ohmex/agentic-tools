# Prompt: Implement Feature

Use this prompt when implementing a new feature end to end.

1. **Understand requirements.** Restate the feature in your own words. Identify the tenant/permission model it touches. Ask clarifying questions if the request is ambiguous — do not assume.
2. **Consult context.** Read `ai/context/architecture.md`, `domain-model.md`, and `tenancy.md`. Identify which service(s) own the relevant data.
3. **Design.** If the feature crosses a service boundary or changes the domain model, draft an ADR using `ai/templates/adr.md` before writing code.
4. **Implement.**
   - Handler → Service → Repository layering (`ai/rules/architecture.md`).
   - Follow `ai/examples/service.md` and `ai/examples/repository.md` for canonical patterns.
   - Update the OpenAPI spec alongside handler changes.
5. **Write unit tests** for all new service-layer logic (`ai/rules/testing.md`).
6. **Write integration tests** for repository/DB behavior, including RLS/tenant isolation.
7. **Write Playwright tests** for user-facing flows: happy path, validation failure, permission failure (`ai/rules/playwright.md`).
8. **Update docs**: README, OpenAPI, glossary if new domain terms were introduced.
9. **Self-check against** `ai/checklists/definition-of-done.md`.
10. **List changed files** with a one-line description of each change.
