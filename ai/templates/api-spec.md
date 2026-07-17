# API Spec: {Endpoint Name}

## Summary

One-sentence description of what this endpoint does.

## Endpoint

`{METHOD} /v1/{path}`

## Auth

- Requires: OIDC JWT / public
- Tenant scoping: derived from JWT claim `tenant_id`
- Required role/permission: {role}

## Request

```json
{
  "field": "type — description"
}
```

## Response — 2xx

```json
{
  "field": "type — description"
}
```

## Errors

| Status | Code | When |
|---|---|---|
| 400 | `validation_error` | |
| 403 | `forbidden` | |
| 404 | `not_found` | |
| 409 | `conflict` | |

## Notes

Pagination, idempotency, rate limits, or other cross-cutting behavior specific to this endpoint.
