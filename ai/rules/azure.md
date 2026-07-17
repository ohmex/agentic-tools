# Azure Rules

- Secrets and connection strings come from Azure Key Vault exclusively, accessed via managed identity (workload identity in AKS) — never via a stored client secret or key committed anywhere.
- Every AKS workload uses a dedicated managed identity scoped to only the Azure resources it needs (least privilege) — no shared "god" identity across services.
- Infrastructure is defined as code (Terraform/Bicep), never provisioned manually through the Azure Portal for anything beyond local experimentation.
- Storage (Blob, Postgres, Service Bus) is provisioned with tenant-data-appropriate redundancy and region settings matching data residency requirements — check `ai/context/tenancy.md` and any compliance constraints before choosing region/replication.
- Network access to data stores (Postgres, Storage, Key Vault) is restricted via private endpoints/VNet integration — no public network access unless explicitly justified.
- Cost-relevant resources (VM sizes, autoscale bounds, storage tiers) are reviewed against actual usage before provisioning — don't default to oversized SKUs "to be safe."
- Every resource is tagged with `service`, `environment`, and `owner` for cost attribution and cleanup.
- Service Bus / Event Grid usage follows the same idempotency and dead-lettering expectations as Kafka (`ai/rules/messaging.md`) where used as an alternative or complementary message bus.
