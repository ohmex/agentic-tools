# Configuration Management Rules

- Follow 12-factor: configuration comes from the environment (env vars, mounted config), never hardcoded or baked into images.
- Strict separation between **config** (non-sensitive, e.g. feature flags, timeouts, log level) and **secrets** (credentials, keys) — secrets always come from Azure Key Vault, never plain env vars or ConfigMaps (`ai/rules/security.md`, `ai/rules/azure.md`).
- Every config value has a sane, safe default for local development; production values are never required to run the service locally against a local/test dependency set.
- Config is validated at startup — fail fast with a clear error if a required value is missing or malformed, not a cryptic failure deep in a request path.
- No environment-specific branching in application code (`if env == "prod"`) — behavior differences are driven by config values, not conditionals on environment name.
- Document every config value's purpose, default, and valid range in the service README or a dedicated config reference — no undocumented environment variables.
- Config changes that alter behavior in production go through the same review process as code changes — no untracked manual overrides in a running environment.
