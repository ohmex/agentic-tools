# CI/CD Rules

- Every PR must pass before merge: lint, unit tests, integration tests, vulnerability scan (`govulncheck`/`npm audit` or equivalent), and build.
- Static analysis (SAST) and dependency scanning (SCA) run as merge gates, not optional/advisory steps — treat high/critical findings as blocking, same as a failing test.
- Secret-detection scanning runs on every PR, before merge — a leaked credential is a blocking finding regardless of how small the diff is.
- Infrastructure-as-code (Terraform/Bicep/Kubernetes manifests) is scanned for misconfiguration in CI, matching `ai/rules/kubernetes.md` and `ai/rules/azure.md`.
- Dynamic analysis (DAST) runs against staging as part of the deployment pipeline for internet-facing services, not just SAST at build time.
- Playwright/E2E suites run at minimum before deploying to staging/production, and ideally on PRs touching user-facing flows.
- Images are built once in CI and promoted unchanged across environments (build once, deploy many) — never rebuild per environment, to guarantee what's tested is what ships.
- Every image is tagged with an immutable identifier (git SHA or semantic version), never `latest`, matching `ai/rules/kubernetes.md`.
- Deployments are automated (GitOps or pipeline-driven) — no manual `kubectl apply`/`helm upgrade` against production.
- Migrations run as a distinct, ordered pipeline step before the new application version is rolled out, and are safe to run against the still-running previous version (expand/contract, `ai/rules/migrations.md`).
- Failed pipeline steps block promotion to the next environment — no manual override without an documented, reviewed exception.
- Secrets used in CI (deploy credentials, registry tokens) are stored in the CI system's secret store, never in the pipeline definition file itself.
- Pipeline definitions are version-controlled and reviewed like any other code change.
