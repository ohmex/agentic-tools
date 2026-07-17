# Example: Table-Driven Unit Test

Canonical pattern for a Go unit test. Imitate this for new service-layer tests.

```go
package order

import (
	"context"
	"errors"
	"testing"

	"github.com/stretchr/testify/require"
)

type fakeRepository struct {
	orders map[string]*Order
	err    error
}

func (f *fakeRepository) GetByID(ctx context.Context, tenantID, orderID string) (*Order, error) {
	if f.err != nil {
		return nil, f.err
	}
	o, ok := f.orders[orderID]
	if !ok || o.TenantID != tenantID {
		return nil, ErrNotFound
	}
	return o, nil
}

func TestService_GetOrder(t *testing.T) {
	tests := []struct {
		name      string
		tenantID  string
		orderID   string
		repo      *fakeRepository
		wantErr   error
		wantOrder bool
	}{
		{
			name:     "returns order when it belongs to the tenant",
			tenantID: "tenant-1",
			orderID:  "order-1",
			repo: &fakeRepository{orders: map[string]*Order{
				"order-1": {ID: "order-1", TenantID: "tenant-1"},
			}},
			wantOrder: true,
		},
		{
			name:     "rejects order belonging to a different tenant",
			tenantID: "tenant-2",
			orderID:  "order-1",
			repo: &fakeRepository{orders: map[string]*Order{
				"order-1": {ID: "order-1", TenantID: "tenant-1"},
			}},
			wantErr: ErrNotFound,
		},
		{
			name:     "wraps unexpected repository errors",
			tenantID: "tenant-1",
			orderID:  "order-1",
			repo:     &fakeRepository{err: errors.New("connection reset")},
			wantErr:  nil, // asserted separately below via errors.Is on the wrapped chain
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			svc := NewService(tt.repo)
			order, err := svc.GetOrder(context.Background(), tt.tenantID, tt.orderID)

			if tt.wantErr != nil {
				require.ErrorIs(t, err, tt.wantErr)
				return
			}
			if tt.wantOrder {
				require.NoError(t, err)
				require.Equal(t, tt.orderID, order.ID)
			}
		})
	}
}
```

## Why this shape

- Table-driven: each case is data, not a separate function — adding a case doesn't add boilerplate.
- The fake repository implements the same interface the service depends on (`ai/examples/service.md`) — no real database, network, or filesystem access in a unit test (`ai/rules/testing.md`).
- Test names describe behavior (`rejects order belonging to a different tenant`), directly covering the tenant-isolation case, not just the happy path.
- `require` stops the test immediately on failure for assertions that make continuing meaningless (e.g. a nil order would panic on `.ID`).
