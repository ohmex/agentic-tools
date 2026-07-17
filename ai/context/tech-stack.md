# Tech Stack

> Keep versions current so the AI doesn't guess at APIs that have since changed. Update whenever a major dependency is upgraded.

## Languages & frameworks

| Component | Choice | Version | Notes |
|---|---|---|---|
| Backend language | Go | {version} | |
| HTTP framework | Echo | {version} | |
| Database driver | pgx / pgxpool | {version} | |
| Frontend | {framework, e.g. React} | {version} | |
| E2E testing | Playwright | {version} | |

## Infrastructure

| Component | Choice | Notes |
|---|---|---|
| Database | PostgreSQL | {version}; RLS for tenant isolation |
| Cache | Redis | {version/managed offering} |
| Messaging | Kafka | {version/managed offering, e.g. Azure Event Hubs Kafka-compatible endpoint} |
| Container orchestration | Kubernetes (AKS) | {version} |
| Service mesh | Istio | {version} |
| Cloud provider | Azure | primary regions: {list} |
| Identity | OIDC provider | {provider name} |

## Key libraries

> List libraries the AI should prefer reusing over introducing an alternative (`ai/rules/dependency-management.md`).

| Purpose | Library |
|---|---|
| Logging | {e.g. zerolog / zap} |
| Metrics/tracing | OpenTelemetry |
| Validation | {e.g. go-playground/validator} |
| Migrations | {e.g. golang-migrate, atlas} |
| Mocking | {e.g. mockery} |

## Linting/tooling

- `golangci-lint` config: {path}
- Pre-commit hooks: {list, if any}
