# Git Rules

- Commit messages follow Conventional Commits: `<type>[optional scope]: <description>` (e.g. `fix(orders): correct rounding for zero-decimal currencies`), imperative mood, concise subject line (~50 chars). Add a body after a blank line for the "why" if not obvious.
- Common types: `feat` (MINOR version bump), `fix` (PATCH bump), plus `docs`, `test`, `chore`, `refactor`, `perf`, `style`, `ci`, `build`.
- Breaking changes are marked either with `!` after the type/scope (`feat(api)!: remove deprecated v1 endpoint`) or a `BREAKING CHANGE:` footer — either correlates with a MAJOR version bump.
- Branch naming follows Gitflow (`ai/rules/gitflow.md`): `feature/{ticket-id}-{short-description}`, `release/vX.Y.Z`, `hotfix/vX.Y.Z-{short-description}`.
- Keep PRs small and reviewable — one logical change per PR. If a change bundles a refactor and a feature, split them.
- PR description follows `ai/templates/pr-description.md`: summary, why, test plan, risk/rollback notes.
- Never force-push to a shared branch (`main`, `develop`, release/hotfix branches) without explicit team agreement.
- Squash-merge feature branches into `develop` to keep history readable; preserve meaningful multi-commit history only for large, deliberately staged changes.
- Never commit directly to `main` or `develop` — all changes go through a PR with at least one review and passing CI, even for urgent fixes (use a hotfix branch with expedited review, not a bypass).
- Never commit secrets, `.env` files, or credentials — if one is committed accidentally, treat it as compromised: rotate it, don't just remove it from a later commit.
