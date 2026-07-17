# Example: Repository Layer

Canonical pattern for a PostgreSQL-backed repository. Imitate this for new repositories.

```go
package order

import (
	"context"
	"database/sql"
	"errors"
	"fmt"

	"github.com/jackc/pgx/v5/pgxpool"
)

var ErrNotFound = errors.New("order: not found")

type PostgresRepository struct {
	db *pgxpool.Pool
}

func NewPostgresRepository(db *pgxpool.Pool) *PostgresRepository {
	return &PostgresRepository{db: db}
}

func (r *PostgresRepository) GetByID(ctx context.Context, tenantID, orderID string) (*Order, error) {
	const q = `
		SELECT id, tenant_id, status, created_at
		FROM orders
		WHERE tenant_id = $1 AND id = $2
	`
	var o Order
	err := r.db.QueryRow(ctx, q, tenantID, orderID).Scan(&o.ID, &o.TenantID, &o.Status, &o.CreatedAt)
	if err != nil {
		if errors.Is(err, sql.ErrNoRows) {
			return nil, ErrNotFound
		}
		return nil, fmt.Errorf("querying order %s: %w", orderID, err)
	}
	return &o, nil
}

func (r *PostgresRepository) Create(ctx context.Context, o *Order) error {
	const q = `
		INSERT INTO orders (id, tenant_id, status, created_at)
		VALUES ($1, $2, $3, now())
	`
	if _, err := r.db.Exec(ctx, q, o.ID, o.TenantID, o.Status); err != nil {
		return fmt.Errorf("inserting order %s: %w", o.ID, err)
	}
	return nil
}
```

## Why this shape

- Every query includes an explicit `tenant_id` predicate — RLS is a second line of defense, not the only one.
- Columns are listed explicitly; no `SELECT *`.
- Driver-specific errors (`sql.ErrNoRows`) are translated into domain errors (`ErrNotFound`) before leaving the repository.
- Parameterized queries only — never string-built SQL.
