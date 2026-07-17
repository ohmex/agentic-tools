# Example: Kafka Consumer

Canonical pattern for an idempotent Kafka consumer. Imitate this for new consumers.

```go
package orderevents

import (
	"context"
	"errors"
	"fmt"
)

type OrderCreatedEvent struct {
	EventID    string `json:"event_id"`
	TenantID   string `json:"tenant_id"`
	OrderID    string `json:"order_id"`
	OccurredAt string `json:"occurred_at"`
	TraceID    string `json:"trace_id"`
}

type ProcessedEventStore interface {
	IsProcessed(ctx context.Context, eventID string) (bool, error)
	MarkProcessed(ctx context.Context, eventID string) error
}

type Handler struct {
	processed ProcessedEventStore
	svc       *NotificationService
}

func (h *Handler) HandleOrderCreated(ctx context.Context, evt OrderCreatedEvent) error {
	done, err := h.processed.IsProcessed(ctx, evt.EventID)
	if err != nil {
		return fmt.Errorf("checking processed status for event %s: %w", evt.EventID, err)
	}
	if done {
		return nil // already handled — Kafka delivers at-least-once, this makes handling idempotent
	}

	if err := h.svc.NotifyOrderCreated(ctx, evt.TenantID, evt.OrderID); err != nil {
		return fmt.Errorf("notifying for order %s: %w", evt.OrderID, err)
	}

	if err := h.processed.MarkProcessed(ctx, evt.EventID); err != nil {
		return fmt.Errorf("marking event %s processed: %w", evt.EventID, err)
	}
	return nil
}

// Consume is called by the Kafka client's message loop. Returning an error here means the
// message is NOT committed and will be retried per the consumer group's retry/backoff policy;
// after the retry budget is exhausted, route to the dead-letter topic — never drop silently.
func (h *Handler) Consume(ctx context.Context, raw []byte) error {
	var evt OrderCreatedEvent
	if err := unmarshal(raw, &evt); err != nil {
		return errors.New("malformed event: routing directly to DLQ, not retrying")
	}
	return h.HandleOrderCreated(ctx, evt)
}

func unmarshal(raw []byte, v any) error { return nil }
```

## Why this shape

- Idempotency is enforced via an explicit `event_id` dedup check, not an assumption about Kafka delivery semantics (`ai/rules/messaging.md`).
- The offset/message is only considered "done" (committed) after both the side effect and the dedup marker succeed — a crash between them causes a safe re-delivery, not silent loss.
- Malformed messages are distinguished from transient failures: malformed goes straight to DLQ (retrying won't fix a bad payload), transient failures get retried per the consumer's backoff policy.
