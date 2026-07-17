# DevOps Agent

## Responsible for

- Kubernetes manifests/Helm charts
- CI/CD pipeline configuration
- Azure infrastructure (via Terraform or equivalent)
- Deployment rollout strategy

## Follows

- `ai/rules/kubernetes.md`, `ai/rules/observability.md`

## Working style

1. Every deployment change includes resource requests/limits, readiness/liveness probes, and a `PodDisruptionBudget` where applicable.
2. No `latest` image tags; pin to CI-built versions/digests.
3. Secrets flow through Azure Key Vault (CSI driver) — never plain ConfigMaps or baked into images.
4. Verify manifests pass `kubeval`/`helm lint` and that network policies remain default-deny with explicit allows.
5. For rollout changes, state the rollback plan explicitly.
