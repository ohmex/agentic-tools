# Go Rules

## Target version: Go 1.25

- `go.mod` pins the `go` directive to `1.25` (or the current agreed minor version — keep this in sync with `ai/context/tech-stack.md`); don't write code that silently relies on a newer or older toolchain's behavior.
- Use `range over func` iterators (`iter.Seq`/`iter.Seq2`) for custom iteration instead of building intermediate slices, where it genuinely simplifies the call site — don't force it where a plain slice-returning function is clearer.
- Use `testing/synctest` for testing concurrent/time-dependent code (timers, goroutine scheduling) instead of real `time.Sleep`-based flakiness.
- Take advantage of improved generic type inference — don't over-annotate type parameters the compiler can now infer.
- Use the standard library's `slices`/`maps`/`cmp` packages instead of hand-rolled helpers or third-party utility packages for common slice/map operations.
- Run `go vet` and `golangci-lint` configured for the pinned Go version — don't let CI silently use an older toolchain than local dev.

- Never `panic` in request-handling paths. Panics are only acceptable at program startup for unrecoverable config errors.
- Always wrap errors with context using `fmt.Errorf("doing X: %w", err)`. Never return a bare error up more than one layer without context.
- Use `errors.Is` / `errors.As` for error checking, never string comparison on error messages.
- Every exported function, type, and package needs a doc comment.
- Prefer standard library over dependencies. Justify new third-party packages in the PR description.
- Use `context.Context` as the first parameter for anything that does I/O; never store it in a struct.
- No naked returns in functions longer than a few lines.
- Structs implementing an interface should be validated with a compile-time assertion: `var _ SomeInterface = (*impl)(nil)`.
- Use table-driven tests. Use `testify/require` for assertions that should stop the test, `assert` for those that shouldn't.
- Run `golangci-lint` before considering any change complete; fix all reported issues, don't suppress with `//nolint` unless justified in a comment.
- Concurrency: never launch a goroutine without a clear owner for its lifecycle (cancellation via context, WaitGroup, or errgroup). No fire-and-forget goroutines in request paths.
- Repository methods return domain errors (e.g. `ErrNotFound`), never raw `sql.ErrNoRows` or driver-specific errors, to the service layer.
- No `init()` functions for initialization logic — make setup explicit and testable (e.g. a `New(...)` constructor called from `main`), not a hidden side effect of importing a package.
- Prefer generics over `interface{}`/`any` when a function or type needs to work across multiple concrete types with shared behavior.
- Interface names describing a single behavior end in `-er` (`Reader`, `Validator`), matching stdlib convention.
- Accept interfaces, return concrete types — a function's parameters should be the narrowest interface it needs; its return value should be a concrete type callers can fully inspect.
- Replace magic numbers/strings with named constants — a literal like `30` or `"admin"` reappearing in logic should be a declared `const` explaining what it represents.
- Names should be descriptive and unabbreviated unless the abbreviation is universally understood in Go (`ctx`, `err`, `id`); avoid redundant stutter (`order.ID`, not `order.OrderID`).
- Default to unexported identifiers; export only what callers outside the package genuinely need — encapsulation is the default, not an afterthought.
- Group imports in the standard order (stdlib, then third-party, then internal packages), separated by blank lines — enforced by `goimports`/`gofmt`, not manual ordering.
