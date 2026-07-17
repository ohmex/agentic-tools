# Docker Rules

- Pin base image versions explicitly (e.g. `golang:1.22-alpine3.19`) — never `:latest`, matching the immutable-tag rule for deployed images (`ai/rules/kubernetes.md`, `ai/rules/ci-cd.md`).
- Use multi-stage builds for Go services: build in a full SDK image, copy only the compiled binary into a minimal runtime image (`distroless` or `alpine`).
- Run as a non-root user — create and switch to a dedicated user in the Dockerfile, never rely on the base image's default root user.
- Order layers for cache efficiency: copy dependency manifests (`go.mod`/`go.sum`) and install/download dependencies before copying application source, so source-only changes don't invalidate the dependency layer.
- Use `COPY`, not `ADD`, unless you specifically need `ADD`'s remote-URL or archive-extraction behavior.
- Define a `HEALTHCHECK` (or rely on the equivalent Kubernetes probe if the orchestrator already covers it — don't duplicate conflicting health logic).
- Never embed secrets, `.env` files, or credentials in image layers or build args — pull them at runtime from Azure Key Vault (`ai/rules/azure.md`).
- Application logs go to stdout/stderr only — never write logs to a file inside the container.
- Scan images for vulnerabilities (Trivy or equivalent) in CI (`ai/rules/ci-cd.md`) and block promotion on high/critical findings.
- Use named volumes for anything needing persistence in local/dev compose setups; bind mounts are for local development convenience only, never a production pattern.

## Docker Compose (local development only)

- Compose is for local development and CI test environments — never a production deployment target; production always runs on Kubernetes (`ai/rules/kubernetes.md`).
- Omit the obsolete top-level `version:` key — modern Compose ignores it and it invites confusion about which schema is in effect.
- Name services after the actual service they represent (`order-service`, `postgres`, `redis`), not generic names like `app`/`db1` — these names become DNS hostnames other services in the same Compose network use to reach them.
- Use `depends_on` with `condition: service_healthy` (backed by a real `healthcheck`) for services with a startup order dependency (e.g. app waiting on Postgres) — a bare `depends_on` only waits for container start, not readiness.
- Load environment-specific values from an `.env` file (gitignored) referenced via `env_file:`, with a committed `.env.example` documenting required variables — never hardcode secrets directly in `docker-compose.yml`.
- Use a dedicated bridge network per Compose project (Compose creates one by default) rather than `network_mode: host`, so service-to-service DNS resolution matches how services will actually address each other via Kubernetes DNS in higher environments.
- Keep the Compose file's service definitions close to what Kubernetes will actually run (same image, same env var names) so local dev is a faithful approximation of `ai/context/environments.md`'s dev/staging topology, not a divergent setup.
