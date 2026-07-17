# Example: Auth & Tenant-Context Middleware

Canonical pattern for Echo middleware that validates the OIDC JWT and injects tenant context. Imitate this for new middleware.

```go
package middleware

import (
	"context"
	"errors"
	"net/http"

	"github.com/labstack/echo/v4"
)

type contextKey string

const tenantIDKey contextKey = "tenant_id"
const userIDKey contextKey = "user_id"

// Auth validates the JWT and injects tenant/user identity into the request context.
// It must run before any handler that calls TenantIDFromContext.
func Auth(verifier TokenVerifier) echo.MiddlewareFunc {
	return func(next echo.HandlerFunc) echo.HandlerFunc {
		return func(c echo.Context) error {
			token, err := extractBearerToken(c.Request())
			if err != nil {
				return echo.NewHTTPError(http.StatusUnauthorized, errEnvelope("unauthorized", "missing or malformed token"))
			}

			claims, err := verifier.Verify(c.Request().Context(), token) // checks signature, issuer, audience, expiry
			if err != nil {
				return echo.NewHTTPError(http.StatusUnauthorized, errEnvelope("unauthorized", "invalid token"))
			}

			ctx := context.WithValue(c.Request().Context(), tenantIDKey, claims.TenantID)
			ctx = context.WithValue(ctx, userIDKey, claims.UserID)
			c.SetRequest(c.Request().WithContext(ctx))
			return next(c)
		}
	}
}

func TenantIDFromContext(c echo.Context) string {
	tenantID, _ := c.Request().Context().Value(tenantIDKey).(string)
	return tenantID
}

func UserIDFromContext(c echo.Context) string {
	userID, _ := c.Request().Context().Value(userIDKey).(string)
	return userID
}

var ErrMissingToken = errors.New("missing bearer token")

func extractBearerToken(r *http.Request) (string, error) {
	// implementation: parse "Authorization: Bearer <token>"
	return "", ErrMissingToken
}
```

## Why this shape

- Tenant ID and user ID are derived **only** from a signature-, issuer-, audience-, and expiry-validated token — never from a header or query param a client could forge.
- Downstream handlers retrieve identity via `TenantIDFromContext`/`UserIDFromContext`, never by re-parsing the token themselves — one validation point.
- Middleware order matters: `Auth` must run before any handler or subsequent middleware that depends on tenant context (e.g. rate limiting per tenant, RLS session setup).
- Failures return the standard error envelope (`ai/rules/api-design.md`) with `401`, never leaking why validation failed in detail (no "expired" vs "bad signature" distinction exposed to the client).
