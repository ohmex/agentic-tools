# Gitflow Rules

- `main` and `develop` are protected — no direct commits to either; all changes land via pull request with required status checks and at least one review.
- **Feature branches** (`feature/{ticket-id}-{short-description}`) branch from `develop` and merge back into `develop` only.
- **Release branches** (`release/vX.Y.Z`) branch from `develop` when preparing a release. Only bug fixes, documentation, and release-oriented tasks are allowed on a release branch — no new features. When ready, merge into both `main` (tagged `vX.Y.Z`) and back into `develop`.
- **Hotfix branches** (`hotfix/vX.Y.Z-{short-description}`) branch from `main` for urgent production fixes. Merge into both `main` (tagged) and back into `develop` — never let a hotfix exist only on `main` or only on `develop`.
- Every merge to `main` is tagged with a semantic version (`MAJOR.MINOR.PATCH`) per `ai/rules/git.md`'s Conventional Commits typing (breaking → MAJOR, `feat` → MINOR, `fix` → PATCH).
- Branches must be up to date with their base branch before a PR can merge — rebase or merge the base in, resolve conflicts, then re-run CI.
- Delete branches after merge; don't let stale feature/release/hotfix branches accumulate.
- Branch protection applies to everyone, including admins — no bypassing review or CI on `main`/`develop` regardless of urgency; use a hotfix branch with expedited review instead.
