# SQL Server Rules

- Every tenant-scoped table has a `TenantId` (`UNIQUEIDENTIFIER` or `INT`, matching the platform's tenant ID type) column and, where supported, a Security Predicate enforced via Row-Level Security — the same defense-in-depth expectation as `ai/rules/postgres.md`'s RLS rule, adapted to SQL Server's RLS mechanism (`CREATE SECURITY POLICY`).
- Use `DATETIME2` (or `DATETIMEOFFSET` when timezone-awareness matters) for all timestamp columns — never the legacy `DATETIME` type, which has poor precision and range.
- Prefer `UNIQUEIDENTIFIER` for IDs exposed externally or replicated; use sequential/clustered-friendly keys (`BIGINT IDENTITY`, or `NEWSEQUENTIALID()` if a GUID is required) for internal primary keys to avoid clustered-index fragmentation from random GUID inserts.
- Every foreign key specifies explicit `ON DELETE`/`ON UPDATE` behavior — never leave it to the default `NO ACTION` without a deliberate reason.
- Use `CHECK` constraints for domain invariants at the schema level, not application code alone.
- No `SELECT *` in application code — list columns explicitly.
- Always use parameterized queries (via Dapper, EF Core, or explicit `SqlParameter`) — never build T-SQL via string concatenation with user input.
- Wrap multi-statement writes in an explicit transaction (`BEGIN TRAN` / EF Core `SaveChanges` within a `TransactionScope` or explicit transaction) with a clear commit/rollback boundary.
- Set an explicit command timeout on every query — a runaway query should time out, not hold a connection indefinitely.
- Use `NOLOCK`/`READ UNCOMMITTED` only with a documented, deliberate reason (accepting dirty reads) — never as a default habit to "avoid blocking."
- Index every foreign key column and every column used in `WHERE`/`JOIN`/`ORDER BY` on large tables — verify with the actual execution plan (`SET SHOWPLAN_XML ON` / Query Store), not assumption.
- Use filtered indexes (SQL Server's equivalent of Postgres partial indexes) for queries that consistently filter on a subset (e.g. `WHERE IsDeleted = 0`).
- Periodically review Query Store / missing-index DMVs (`sys.dm_db_missing_index_details`) and unused-index DMVs to keep the index set aligned with actual query patterns.
- Name migrations with a strict, tool-enforced order (EF Core migrations timestamp-prefixed, or Flyway/DbUp `V001__description.sql` if used) — never hand-edit an already-applied migration.
- Migrations are additive and backward-compatible by default (expand/contract, `ai/rules/migrations.md`): add nullable columns first, backfill, then tighten constraints in a follow-up migration — the same pattern regardless of database engine.
- Avoid N+1 query patterns from an ORM (EF Core) — use explicit `.Include()`/projection or a batched query instead of looping queries per row.
