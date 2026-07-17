# Documentation Rules

- Every service has a `README.md` covering: purpose, owned data, public API, how to run locally, how to test.
- API changes are reflected in the OpenAPI spec in the same PR — no undocumented endpoints.
- Architectural decisions with lasting consequence are captured as an ADR (`ai/templates/adr.md`) in `docs/adr/`, not just in a PR description.
- Keep `ai/context/` up to date when architecture, domain model, or tenancy rules change — these are consulted before every non-trivial task.
- Comments in code explain *why*, not *what* — the code itself should make the "what" obvious.
- Runbooks exist for every alert (see `ai/rules/observability.md`) and are kept next to the service they cover.
- Glossary (`ai/context/glossary.md`) is updated whenever a new domain term is introduced.
