# Kubernetes Rules

- Every deployment defines resource `requests` and `limits` for CPU and memory — no unbounded pods.
- Every deployment defines `readinessProbe` and `livenessProbe` matching the service's actual health-check endpoint.
- Use `PodDisruptionBudget` for any service with more than one replica.
- No `latest` image tags — always pin to a specific version/digest built by CI.
- Secrets are mounted via `Secret`/`Azure Key Vault CSI driver`, never baked into images or plain ConfigMaps.
- Namespaces separate environments and, where applicable, tenants with elevated isolation needs.
- Network policies default-deny; explicitly allow only required service-to-service traffic.
- Horizontal Pod Autoscaler configured for any service with variable load, based on CPU/memory or custom metrics.
- All manifests/Helm charts pass `kubeval`/`helm lint` in CI before merge.
- Rolling updates use `maxUnavailable: 0` for services that can't tolerate downtime; document any exception.

## k3s (local / edge clusters)

- Manifests and Helm charts must work unmodified on both AKS (production) and k3s (local dev/edge) — avoid AKS-only APIs or annotations in shared charts; isolate cloud-specific config (e.g. Azure CSI driver, Azure Key Vault CSI) behind values-file overrides per environment.
- k3s's bundled Traefik ingress is fine for local/edge use, but don't write ingress rules relying on Traefik-only annotations if the same chart must also deploy behind AKS's ingress controller — prefer the standard `networking.k8s.io/Ingress` spec and keep controller-specific behavior in per-environment values.
- k3s's embedded SQLite/etcd datastore is for single-node or small edge clusters only — never treat a k3s cluster's built-in datastore as a model for production HA; production always uses managed PostgreSQL (`ai/rules/azure.md`), not cluster-local state.
- Use `k3d` (k3s in Docker) for local development clusters so engineers can run the full manifest set locally before pushing — document the local cluster bootstrap steps in the relevant service README.
- Resource requests/limits tuned for AKS node sizes may not fit k3s edge/local hardware — scale them down via environment-specific values rather than editing the base chart, and document the divergence in `ai/context/environments.md`.
