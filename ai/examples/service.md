# Example: Service Layer

Canonical pattern for a service-layer type. Imitate this structure for new services rather than inventing a new shape.

```go
package order

import (
	"context"
	"fmt"
)

type Repository interface {
	GetByID(ctx context.Context, tenantID, orderID string) (*Order, error)
	Create(ctx context.Context, o *Order) error
}

type Service struct {
	repo Repository
}

func NewService(repo Repository) *Service {
	return &Service{repo: repo}
}

func (s *Service) GetOrder(ctx context.Context, tenantID, orderID string) (*Order, error) {
	o, err := s.repo.GetByID(ctx, tenantID, orderID)
	if err != nil {
		return nil, fmt.Errorf("getting order %s for tenant %s: %w", orderID, tenantID, err)
	}
	return o, nil
}

func (s *Service) CreateOrder(ctx context.Context, tenantID string, input CreateOrderInput) (*Order, error) {
	if err := input.Validate(); err != nil {
		return nil, fmt.Errorf("validating create order input: %w", err)
	}

	o := input.ToOrder(tenantID)
	if err := s.repo.Create(ctx, o); err != nil {
		return nil, fmt.Errorf("creating order for tenant %s: %w", tenantID, err)
	}
	return o, nil
}
```

## Why this shape

- The service depends on a `Repository` **interface**, defined here at the point of use — not imported from the repository package's concrete type.
- Every method takes `tenantID` explicitly and passes it through, never relying on ambient/global state.
- Errors are wrapped with enough context to debug without a stack trace.
- Validation happens before any persistence call.
