# Data Privacy & Compliance Rules

- Classify fields containing PII (name, email, phone, address, IP, government IDs) explicitly in the schema/domain model — treat unclassified free-text/JSON blobs as potentially containing PII until proven otherwise.
- Never log PII or secrets, even at `debug` level (`ai/rules/observability.md`). Redact before logging.
- Support data subject rights: every tenant/user's PII must be locatable and deletable/exportable on request (GDPR-style right to erasure/portability) — new tables storing PII must fit into the existing deletion/export tooling, or extend it.
- Data retention is explicit per entity — define how long data is kept after a tenant/user is deleted, and enforce it with a scheduled job, not manual cleanup.
- Cross-border data transfer and residency constraints (per tenant contract/region) are respected when choosing storage region (`ai/rules/azure.md`) — check `ai/context/tenancy.md` before assuming all tenant data can live in one region.
- Encrypt PII at rest (database-level or column-level encryption for the most sensitive fields) and in transit (TLS everywhere, enforced by Istio mTLS).
- Third-party integrations that receive tenant data must be reviewed for their own compliance posture before integration — document the data shared and why in `ai/context/integrations.md`.
- Any new feature that collects, stores, or shares a new category of personal data needs a privacy review, not just a security review — flag it explicitly rather than assuming standard security review covers it.
