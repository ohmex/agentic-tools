# Migration Rules

- Migrations must be backward-compatible with the currently deployed code (expand/contract pattern):
  1. **Expand**: add new nullable column/table (deploy).
  2. **Migrate**: backfill data, dual-write if needed (deploy).
  3. **Contract**: add `NOT NULL`/drop old column, remove dual-write (deploy, separate release).
- Never rename or drop a column/table in the same migration that also removes application code depending on it — always sequence expand/contract across releases.
- Every migration has a corresponding down-migration that safely reverses it, unless explicitly irreversible (documented why).
- Adding a `NOT NULL` column to an existing table requires a `DEFAULT` or a backfill step first — never lock a large table with a blocking rewrite.
- New indexes on large tables are created `CONCURRENTLY` to avoid locking writes.
- RLS policies are added in the same migration that creates a new tenant-scoped table — never shipped as a follow-up.
- Migrations are numbered/timestamped and run in strict order by the migration tool; never edit an already-applied migration — write a new one.
- Every migration is reviewed for lock duration and applied against a production-sized dataset copy when touching tables over ~1M rows.

