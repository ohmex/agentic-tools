# Playwright Rules

- One spec file per user-facing feature/flow, named after the flow (`checkout.spec.ts`, not `page1.spec.ts`).
- Use role-based locators (`getByRole`, `getByLabel`) over CSS selectors or `data-testid` unless no accessible role exists.
- Every flow test covers: happy path, at least one validation/negative case, and a permission-denied case where relevant (RBAC/tenant boundary).
- Always test across the primary breakpoint set: desktop and mobile viewport, at minimum.
- Auth in tests goes through the real OIDC flow against a test IdP, or a pre-seeded storage state — never bypass auth with test-only backdoors that could leak into production code paths.
- No hardcoded sleeps (`page.waitForTimeout`). Wait on explicit conditions (`waitForResponse`, `expect(locator).toBeVisible()`).
- Each test is independent and idempotent — seed its own data, clean up after itself, no ordering dependence between tests.
- Visual/UI changes should include a Playwright test asserting the new behavior, not just a manual QA note.
- Mock external third-party APIs via `page.route` so E2E tests stay deterministic and fast — don't let a flow test's reliability depend on a live third party.
- Keep each spec file focused: roughly 3-5 tests per file, organized under `test.describe`, with a `test.beforeEach` for shared setup. Split further if a file grows beyond that.

