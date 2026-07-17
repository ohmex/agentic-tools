# Engineering Rules

- Optimize for readability and maintainability over cleverness. Code is read far more than it is written.
- Prefer explicit over implicit. No hidden magic, no global mutable state.
- Keep functions small and single-purpose. If a function needs a comment to explain "what", split it.
- Every public function/type needs a doc comment describing *why* it exists if not obvious from its name.
- No dead code, commented-out code, or TODOs without an owner and a linked ticket.
- Fail fast and loud in development; fail safe and logged in production.
- Never swallow errors silently. Every error is either handled, wrapped with context, or returned.
- Prefer composition over inheritance-like patterns; favor interfaces defined at the point of use, not the point of implementation.
- Consistency with existing patterns in the codebase beats "a better way" — propose changes via ADR, don't silently diverge.
- Don't repeat yourself: extract genuinely repeated logic into a shared, well-named function rather than copy-pasting — but don't abstract something that's only appeared once (see anti-over-engineering below).
- Every change that touches behavior needs a test. Every change that touches the API needs updated OpenAPI docs.
- Before writing new code, check `ai/examples/` for the canonical pattern to imitate.
- Consult `ai/context/` for architecture, domain model, and tenancy rules before designing anything cross-cutting.

## Anti-over-engineering

- Change only what was explicitly requested. A bug fix doesn't need surrounding cleanup; a one-shot script doesn't need a reusable framework.
- Default to the simplest solution that satisfies the actual requirement — don't build for hypothetical future needs that haven't been asked for.
- Don't introduce a new abstraction, interface, or dependency without a concrete, current justification. Three similar lines of code is better than a premature abstraction covering a pattern that's only appeared once.
- When a task's scope or requirements are ambiguous, ask before guessing — don't defensively over-build to cover every interpretation.
- Don't rewrite or reformat an entire file for a small change — keep the diff proportional to the task.
- Don't add error handling, validation, or edge-case branches for scenarios that can't actually occur given the system's guarantees — validate at boundaries, trust internal invariants elsewhere.
- Before considering a change done, verify: only the files that needed to change were touched, no unrelated refactors snuck in, and the diff matches the stated scope.
