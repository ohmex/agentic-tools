# Dependency Management Rules

- Prefer the standard library over a new dependency; justify any new third-party package in the PR description (what it does, why it's needed, why nothing existing covers it).
- Pin exact versions in `go.mod`/`package.json` — no floating/range versions for anything deployed to production.
- Run vulnerability scanning (`govulncheck`, `npm audit`, or equivalent) in CI (`ai/rules/ci-cd.md`) and treat high/critical findings as blocking.
- Review new dependencies for license compatibility before adding them — avoid copyleft licenses that conflict with the project's distribution model unless explicitly cleared.
- Keep dependencies reasonably current — schedule periodic (e.g. monthly) dependency update passes rather than letting them drift for years and becoming a risky big-bang upgrade.
- Vendor or checksum-lock dependencies (`go.sum`, lockfiles) are committed and verified in CI — builds must be reproducible.
- Avoid unmaintained or single-maintainer packages for anything security- or correctness-critical (auth, crypto, parsing untrusted input) — prefer well-maintained, widely-used libraries for those paths.
- Removing a dependency: verify it's actually unused (no dynamic/reflective usage) before deleting it from the manifest.
