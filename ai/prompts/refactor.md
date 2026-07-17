# Prompt: Refactor

1. **Confirm behavior is preserved.** Refactors change structure, not behavior. Ensure test coverage exists for the code being touched before starting — add characterization tests first if coverage is thin.
2. **State the goal.** Name the specific problem being solved (duplication, poor testability, tight coupling, etc.) — refactors without a stated goal tend to sprawl.
3. **Refactor in small, reviewable steps.** Prefer several small commits/PRs over one large diff.
4. **Re-run the full test suite** after each step, not just at the end.
5. **Do not mix in new features or bugfixes.** If you find a bug while refactoring, note it and fix it separately unless it blocks the refactor.
6. **Update examples** (`ai/examples/`) if the refactor establishes a new canonical pattern others should imitate.
7. **List changed files** with a one-line description of each change.
