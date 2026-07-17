# Python Rules

- Use `src/`-layout (`src/<package_name>/`) with a parallel `tests/` directory — don't scatter modules at the repo root.
- Format and lint with Ruff (covers what Black + isort + flake8 used to do separately) — run it in CI as a merge gate (`ai/rules/ci-cd.md`).
- Type hints on every function signature and return value — no untyped public functions. Use modern union syntax (`str | None`), not `Optional[str]`, targeting Python 3.10+.
- Use `typing.Protocol` for structural typing/duck-typing interfaces instead of ABCs where you only need to describe shape, not shared implementation — mirrors the "accept interfaces" principle in `ai/rules/golang.md`.
- PEP 8 naming: `snake_case` functions/variables/modules, `PascalCase` classes, `UPPER_CASE` constants. Absolute imports over relative imports.
- Define custom exception classes for domain-specific failures (`class InsufficientFundsError(Exception)`) instead of raising bare `Exception` or built-ins for business errors — catch and handle specific exception types, never a bare `except:`.
- Google-style docstrings on public functions/classes explaining *why*, not restating the signature.
- Never use mutable default arguments (`def f(items=[])`) — use `None` and initialize inside the function.
- Avoid global mutable state; pass dependencies explicitly (constructor/function args) rather than reaching for module-level singletons.
- Test with `pytest` + `pytest-cov` + `pytest-mock`; use fixtures for shared setup and factory functions over static fixtures when generating varied test data. Test error paths explicitly, not just the happy path — aim for high coverage on business-critical modules, not a blanket percentage everywhere.
- Manage dependencies with Poetry (or `uv`) and a lockfile — never install packages ad hoc without updating the lockfile.
- Never commit secrets or credentials — same as `ai/rules/security.md`; pull them from Azure Key Vault / environment injection, never a `.env` committed to the repo.
