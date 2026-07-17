# Example: API Handler

Canonical pattern for an Echo HTTP handler. Imitate this for new endpoints.

```go
package order

import (
	"errors"
	"net/http"

	"github.com/labstack/echo/v4"
)

type Handler struct {
	svc *Service
}

func NewHandler(svc *Service) *Handler {
	return &Handler{svc: svc}
}

func (h *Handler) RegisterRoutes(g *echo.Group) {
	g.GET("/orders/:id", h.getOrder)
	g.POST("/orders", h.createOrder)
}

func (h *Handler) getOrder(c echo.Context) error {
	tenantID := TenantIDFromContext(c) // derived from validated JWT claim, never client input
	orderID := c.Param("id")

	order, err := h.svc.GetOrder(c.Request().Context(), tenantID, orderID)
	if err != nil {
		if errors.Is(err, ErrNotFound) {
			return echo.NewHTTPError(http.StatusNotFound, errEnvelope("not_found", "order not found"))
		}
		return echo.NewHTTPError(http.StatusInternalServerError, errEnvelope("internal_error", "unexpected error"))
	}
	return c.JSON(http.StatusOK, toOrderResponse(order))
}

func (h *Handler) createOrder(c echo.Context) error {
	var req CreateOrderRequest
	if err := c.Bind(&req); err != nil {
		return echo.NewHTTPError(http.StatusBadRequest, errEnvelope("validation_error", err.Error()))
	}

	tenantID := TenantIDFromContext(c)
	order, err := h.svc.CreateOrder(c.Request().Context(), tenantID, req.ToInput())
	if err != nil {
		return echo.NewHTTPError(http.StatusUnprocessableEntity, errEnvelope("validation_error", err.Error()))
	}

	c.Response().Header().Set("Location", "/v1/orders/"+order.ID)
	return c.JSON(http.StatusCreated, toOrderResponse(order))
}
```

## Why this shape

- Handler contains only HTTP concerns: binding, tenant/auth extraction, status codes. No business logic.
- `tenantID` comes from the authenticated context, never from the request body or query params.
- Errors are translated into the standard error envelope (`ai/rules/api-design.md`) with correct status codes.
- `201 Created` responses set `Location`.
