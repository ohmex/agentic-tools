# Third-Party Integrations

> Update whenever a new external service is integrated or one is retired. Referenced by `ai/agents/compliance.md` and `ai/rules/data-privacy.md` — every integration that touches tenant data needs an entry here.

| Integration | Purpose | Data shared | Auth method | Compliance notes |
|---|---|---|---|---|
| {e.g. OIDC provider} | authentication | user identity claims | OIDC/OAuth2 | |
| {e.g. payment processor} | billing | payment tokens, invoice data (no raw card data) | API key / OAuth | PCI scope: {tokenized, out of scope for raw card data} |
| {e.g. email provider} | transactional email | recipient email, message content | API key | |
| {e.g. error tracking / observability SaaS} | monitoring | error payloads, stack traces (scrubbed of PII) | API key | ensure PII scrubbing is verified, not assumed |

## Adding a new integration

1. Document it in the table above before or alongside implementation.
2. Confirm what tenant data is shared and whether it requires a Data Processing Agreement with the vendor.
3. Confirm the integration respects data residency constraints (`ai/context/tenancy.md`, `ai/rules/azure.md`) if tenant data crosses a region boundary.
4. Add credentials via Azure Key Vault (`ai/rules/security.md`) — never inline.
5. Define a fallback/degradation behavior if the integration is unavailable (timeout, circuit breaker) — see `ai/rules/performance.md`.
