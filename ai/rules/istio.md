# Istio Service Mesh Rules

- mTLS is `STRICT` mesh-wide by default. Any `PERMISSIVE` exception must be scoped narrowly (specific namespace/workload) and documented with a reason and expiry.
- Every service-to-service call relies on the mesh for retries/timeouts/circuit-breaking (`DestinationRule` outlier detection) rather than reimplementing it ad hoc in application code — avoid duplicate retry logic at both the mesh and app layer without coordinating their budgets.
- Define explicit `VirtualService` timeout and retry policies for every route — don't rely on Istio defaults for anything latency-sensitive.
- Use `DestinationRule` circuit breaking (`outlierDetection`) for every service so a failing instance is ejected from the load-balancing pool rather than continuing to receive traffic.
- Canary/traffic-shifting rollouts go through Istio traffic splitting (weighted `VirtualService` routes), not ad hoc application-level flags, when doing a progressive deploy.
- Authorization policies (`AuthorizationPolicy`) enforce service-to-service access — a service should only be reachable by the callers it actually expects, mirroring the default-deny network policy stance in `ai/rules/kubernetes.md`.
- Sidecar resource requests/limits are set explicitly — don't let the injected proxy run unbounded alongside the application container.
- Any change to mesh-wide config (mTLS mode, default retry policy) needs an ADR — it affects every service.
