# Angular Rules

- Prefer standalone components (`standalone: true`) over `NgModule`-declared components for new code — don't add new components to an `NgModule`'s `declarations` array unless the surrounding codebase is still module-based and migrating incrementally.
- Use `inject()` for dependency injection in component/service bodies where it simplifies constructor signatures (especially in functional guards/resolvers/interceptors) — constructor injection remains fine for straightforward cases.
- Set `ChangeDetectionStrategy.OnPush` on components by default; only fall back to default change detection with a specific, documented reason.
- Manage RxJS subscriptions safely: use the `async` pipe in templates wherever possible so Angular handles subscribe/unsubscribe automatically; for subscriptions in component code, unsubscribe via `takeUntilDestroyed()` (or a `DestroyRef`-based pattern) — never leave a manual `.subscribe()` without a corresponding teardown.
- Use reactive forms (`FormGroup`/`FormControl` with typed forms) over template-driven forms for anything beyond a trivial single-field form.
- Keep components thin: presentation and user interaction only. Business logic and data access belong in injectable services, mirroring the handler/service separation in `ai/rules/architecture.md`.
- Limit nesting depth (aim for ≤2 levels of conditional/loop nesting in templates and TypeScript) and keep functions short and single-purpose — extract a named method rather than an inline complex expression in a template.
- Use Angular's `HttpClient` with typed responses and centralized interceptors for auth headers, error handling, and retries — don't scatter fetch/header logic across services.
- Lazy-load feature routes (`loadComponent`/`loadChildren`) for anything beyond a small app shell, to keep initial bundle size down.
- Test with Jasmine/Karma or Jest (per project convention) plus `TestBed` for component tests; prefer testing behavior through the DOM/public API over reaching into component internals.
- Follow the project's `.eslintrc`/`.prettierrc`/`angular.json` configuration as the source of truth for formatting and linting — don't hand-format against personal preference.
