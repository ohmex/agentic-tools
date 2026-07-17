# PostgreSQL Rules

- Every tenant-scoped table has a `tenant_id UUID NOT NULL` column and a Row-Level Security policy enforcing it. No exceptions.
- Every table has `created_at`, `updated_at` (and `deleted_at` if soft-deleted) timestamp columns, defaulted and maintained by triggers or the application layer consistently — pick one approach per table and document it.
- All foreign keys are indexed. All columns used in `WHERE`, `JOIN`, or `ORDER BY` on large tables are indexed — verify with `EXPLAIN ANALYZE`.
- No `SELECT *` in application code — always list columns explicitly.
- All multi-statement writes happen inside an explicit transaction with a clear commit/rollback boundary in the service layer.
- Never build SQL via string concatenation with user input. Always use parameterized queries.
- Migrations are additive and backward-compatible by default: add columns as nullable or with defaults, deploy code, then tighten constraints in a follow-up migration. See `ai/rules/migrations.md`.
- Prefer `UUID` (v4 or v7) primary keys over serial integers for anything exposed externally or replicated.
- Avoid N+1 query patterns — use joins or batched `WHERE id = ANY($1)` lookups instead of looping queries.
- Every new query touching a table over ~100k rows needs its `EXPLAIN ANALYZE` plan reviewed before merge — see `ai/agents/database.md`.
- Use `TIMESTAMPTZ` for every timestamp column — never bare `TIMESTAMP` — to avoid timezone ambiguity.
- Use `BIGSERIAL`/`IDENTITY` for internal-only primary keys; reserve `UUID` for any ID exposed externally (API responses, cross-service references) or replicated.
- Every foreign key specifies explicit `ON DELETE` behavior (`CASCADE`, `RESTRICT`, `SET NULL`) — never leave it to the default.
- Use `CHECK` constraints to enforce domain invariants at the database level (e.g. `status IN (...)`, `quantity > 0`), not application code alone.
- Set `statement_timeout` (per role or per session) to bound runaway queries — a slow query should time out, not hold a connection indefinitely.
- Use `SELECT ... FOR UPDATE` when a read-then-write sequence needs row-level locking to prevent lost updates under concurrency.
- Name migration files with a strict version prefix (`V001__description.sql`) so ordering is unambiguous and tooling-enforced.
- Use partial indexes for queries that consistently filter on a subset (e.g. `WHERE deleted_at IS NULL`) instead of a full index that's mostly wasted space.
- Periodically audit for unused indexes (`pg_stat_user_indexes`) and drop them — every index has a write-time cost.

## Citus (distributed Postgres)

- Distribute tenant-scoped tables on `tenant_id` — it's almost always the correct distribution column for a multi-tenant SaaS schema, since it keeps each tenant's data co-located on one shard.
- Every unique constraint (including the primary key) on a distributed table must include the distribution column — Citus cannot enforce global uniqueness across shards otherwise.
- Small, rarely-changing, non-tenant-scoped tables (lookup/reference data shared across all tenants) should be **reference tables** (`create_reference_table`), replicated to every node, so they can be joined locally without cross-shard traffic.
- Colocate related distributed tables on the same distribution column (`tenant_id`) so joins between them execute locally per-shard rather than fanning out across the cluster.
- Avoid queries that join or transact across multiple distribution-column values (cross-shard joins/transactions) — these are slow or unsupported; redesign the query or denormalize instead of forcing a cross-tenant join.
- Choose shard count deliberately at table creation (`citus.shard_count`) based on expected cluster size — increasing shard count later requires a rebalance, not a simple `ALTER TABLE`.
- Use `citus_rebalance_start()` (or the managed equivalent) to rebalance shards after adding worker nodes — don't assume data redistributes automatically.
- For large analytical/append-only tables, consider Citus columnar storage instead of row storage, but only after confirming the access pattern is scan-heavy, not point-lookup-heavy.
