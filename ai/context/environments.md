# Environments

> Update this when environments are added, removed, or their topology changes.

## Environment list

| Environment | Purpose | Region(s) | Data | Access |
|---|---|---|---|---|
| local | developer machine | n/a | synthetic/seed data | unrestricted |
| dev | shared integration testing | {region} | synthetic data, refreshed periodically | engineering team |
| staging | pre-production validation, mirrors prod topology | {region} | anonymized/sampled production-like data | engineering team |
| production | live customer traffic | {region(s)} | real tenant data | restricted, audited access only |

## Differences from production

Document anything staging/dev intentionally does *not* mirror (e.g. reduced replica counts, mocked third-party integrations, relaxed rate limits) so engineers don't draw false conclusions from testing there.

- {e.g. staging uses a single AKS node pool vs. prod's multi-zone pool}
- {e.g. third-party payment provider is sandboxed in staging/dev}

## Promotion path

`local → dev → staging → production`, gated by CI (`ai/rules/ci-cd.md`) and the release checklist (`ai/checklists/release.md`).

## Access control

- Production data access is logged and time-boxed; direct production database access requires {process, e.g. a break-glass procedure}.
- Secrets per environment are isolated in separate Azure Key Vault instances/namespaces — no sharing of prod secrets into lower environments.
