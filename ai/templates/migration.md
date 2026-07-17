# Migration Plan: {Name}

## Goal

What schema change is being made and why.

## Phase 1 — Expand

- [ ] Add new nullable column(s) / table(s)
- [ ] Add RLS policy if new tenant-scoped table
- [ ] Add indexes `CONCURRENTLY`
- [ ] Deploy

## Phase 2 — Migrate

- [ ] Backfill existing data
- [ ] Dual-write from application code if needed
- [ ] Verify data consistency
- [ ] Deploy

## Phase 3 — Contract

- [ ] Remove dual-write
- [ ] Add `NOT NULL` / drop old column
- [ ] Deploy

## Rollback plan

How to revert each phase safely if something goes wrong.

## Risk assessment

- Table size: {rows}
- Expected lock duration: {estimate from EXPLAIN/staging test}
- Blast radius if this goes wrong: {services/features affected}
