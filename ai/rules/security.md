# Security Rules

- Every request handler validates authentication (OIDC-issued JWT) and authorization (RBAC) before touching business logic. No endpoint is unauthenticated unless explicitly documented as public.
- Every tenant-scoped query must include a `tenant_id` predicate, enforced by RLS as a second line of defense — never rely on application code alone.
- No SQL built by string concatenation. Parameterized queries only (see `ai/rules/postgres.md`).
- Secrets (DB credentials, API keys, signing keys) come only from Azure Key Vault / environment injection. Never commit secrets, never log them.
- JWTs are validated for signature, issuer, audience, and expiry on every request. Never trust claims without validating the signature against the OIDC provider's JWKS.
- Apply the principle of least privilege to service accounts, Kubernetes RBAC, and database roles.
- Sanitize and encode all output that reaches a browser context to prevent XSS; use parameterized templates, never string-built HTML.
- Rate-limit and validate all externally-reachable endpoints against abuse (brute force, enumeration).
- Dependency vulnerabilities are tracked and patched — no ignoring `govulncheck`/`npm audit` findings without a documented exception.
- Any change touching auth, tenancy boundaries, or data access must be reviewed against `ai/skills/security/SKILL.md` before merge.
- Log security-relevant events (auth failures, permission denials, tenant-boundary violations) but never log PII or secrets.

## SAML

- SAML is supported as an enterprise SSO option alongside OIDC — both terminate at a single internal identity boundary that issues the platform's own signed session token/JWT; downstream services never parse or trust a raw SAML assertion or OIDC ID token directly.
- Validate SAML responses fully before trusting any assertion: signature (against the IdP's published certificate), `Issuer`, `Audience`/`Recipient`, `NotBefore`/`NotOnOrAfter` conditions, and `InResponseTo` against the original `AuthnRequest` to prevent replay.
- Each tenant's SAML IdP metadata (entity ID, certificate, SSO URL) is configured per-tenant, never shared or defaulted across tenants — a misconfigured or stale IdP mapping is a tenant-isolation bug, not just an auth bug.
- Rotate/monitor IdP signing certificate expiry per tenant and alert before expiry breaks login for that tenant.
- Never accept an unsigned SAML assertion or one signed with an algorithm weaker than RSA-SHA256, regardless of what the IdP offers by default.

## MFA

- MFA enrollment and enforcement policy is configurable per tenant (some tenants may mandate it for all users, others make it optional) — check tenant policy, don't hardcode a single global MFA requirement.
- Support standard second factors (TOTP at minimum; WebAuthn/FIDO2 preferred where available) — avoid SMS-based MFA as the sole option where compliance requirements (`ai/rules/data-privacy.md`) call for phishing-resistant factors.
- Step-up authentication (re-prompt for MFA) is required before sensitive actions (permission changes, data export, billing changes) even within an already-authenticated session — don't treat MFA as a one-time login gate only.
- MFA recovery/bypass flows (backup codes, admin-assisted reset) are logged and rate-limited — this is a common privilege-escalation path if left unguarded.
- Never allow an application code path to silently skip MFA for convenience (e.g. "internal" or "test" accounts) in a production environment.
