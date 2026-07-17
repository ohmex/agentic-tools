# TypeScript / JavaScript Rules

- Enable `strict` mode in `tsconfig.json` — this is foundational, not an optional feature to turn on later.
- Prefer `interface` for object shapes (especially anything extended or implemented elsewhere); use `type` for unions, intersections, and mapped/utility types.
- Never use `any`; use `unknown` for genuinely unknown values and narrow with type guards before use.
- Use generics and built-in utility types (`Partial`, `Pick`, `Omit`, `Record`, etc.) instead of duplicating near-identical type definitions.
- Naming: `PascalCase` for types/interfaces/classes, `camelCase` for variables/functions, `UPPER_CASE` for true constants. Boolean-like names use an auxiliary verb (`isLoading`, `hasError`) so intent is clear at the call site.
- Keep type definitions next to where they're used for local-only types; move shared types to a dedicated types module/barrel export once more than one file depends on them.
- Explicit return types on exported/public functions — inference is fine for private helpers and callbacks, but a public API's return type should be visible without hovering.
- Use `readonly` on properties/arrays that shouldn't mutate after construction — let the compiler enforce immutability instead of a code-review comment.
- Model fallible operations with discriminated unions or a `Result<T, E>`-style type and narrow with type guards, rather than throwing for expected failure paths; reserve `throw`/`try-catch` for genuinely exceptional conditions, with typed catch handling where the runtime supports it.
- Define custom error classes for domain-specific failures (extending `Error`) instead of throwing plain strings or generic `Error` instances.
- Prefer early returns over nested conditionals to keep functions flat; order functions so a parent/orchestrating function appears before the helpers it calls.
- Prefix event handler functions/props with `handle` (`handleSubmit`, `handleClick`) for consistency and quick recognition.
- Use ES module syntax (`import`/`export`) exclusively — no `require`/`module.exports` in new code, even in Node.js tooling scripts.
- JSDoc on exported functions/types where the "why" isn't obvious from the signature — not a restatement of the parameter names.

