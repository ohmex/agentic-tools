# Architecture

> Keep this document current. It is consulted before any cross-cutting design or feature work.

## Overview

Multi-tenant SaaS platform built as a set of microservices.

- **Language/framework:** Go, Echo
- **Data store:** PostgreSQL (row-level security for tenant isolation)
- **Messaging:** Kafka (async/event-driven flows between services)
- **Cache:** Redis
- **Auth:** OIDC (external identity provider), JWT-based service-to-service and user auth
- **Infrastructure:** Kubernetes on Azure (AKS), Istio service mesh
- **Frontend/E2E testing:** Playwright

## Service inventory

> Update this table as services are added, renamed, or retired. Each service owns its own schema — no cross-service table access.

| Service | Owns | Public API | Notes |
|---|---|---|---|
| _e.g. tenant-service_ | tenant records, plans, settings | `/tenants`, `/tenants/{id}/settings` | source of truth for `tenant_id` |
| _e.g. auth-service_ | sessions, RBAC roles | `/auth/*` | integrates with external OIDC provider |

## Communication patterns

- **Synchronous (REST via Echo):** used for request/response calls where the caller needs an immediate result.
- **Asynchronous (Kafka):** used for cross-service side effects, notifications, and eventually-consistent workflows. Prefer this over new synchronous coupling.

## Tenancy model

See `ai/context/tenancy.md` for the full row-level isolation model.

## Adding a new service

1. Register it in the service inventory table above.
2. Define its owned data and public API surface.
3. Write an ADR if it introduces new cross-service communication patterns.
