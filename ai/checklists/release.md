# Release Checklist

- [ ] All migrations for this release follow expand/contract and have been dry-run against a production-sized dataset
- [ ] CI green: unit, integration, and Playwright suites
- [ ] No open blocking findings from code review or security review
- [ ] Feature flags configured correctly for gradual rollout, if applicable
- [ ] Dashboards/alerts updated for any new endpoints, jobs, or metrics
- [ ] Rollback plan documented and understood by whoever is on call
- [ ] Kubernetes manifests reviewed: resource limits, probes, PDB, image tags pinned
- [ ] Secrets/config verified in target environment (Azure Key Vault entries present)
- [ ] Release notes/changelog updated
- [ ] Stakeholders notified of any customer-visible change or planned downtime
