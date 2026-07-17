# C# / .NET Rules

- Naming: `PascalCase` for classes, methods, and public properties; `camelCase` for locals and parameters; `UPPER_CASE` or `PascalCase` constants per existing project convention — match whatever the surrounding project already uses.
- Use modern C# language features where they improve clarity: records for immutable data, pattern matching (`switch` expressions, `is` patterns), null-coalescing/null-conditional operators, `required` members — don't write C# 4-era code in a modern codebase.
- Use `async`/`await` for all I/O-bound operations (DB, HTTP, file); never block on async code with `.Result`/`.Wait()` — that's a common deadlock source in ASP.NET Core.
- Exceptions are for exceptional, unrecoverable conditions — not for expected control flow (e.g. "not found" should be a typed result/null check at the boundary, not a thrown-and-caught exception in the hot path).
- Validate input at the API boundary (model binding + data annotations or FluentValidation); the service layer assumes already-validated input, mirroring `ai/rules/api-design.md`.
- Document the API with Swagger/OpenAPI, generated from XML doc comments on public controller actions and DTOs — keep this in sync with `ai/rules/api-design.md`'s OpenAPI-first workflow.
- Use a layered architecture: API/Controllers → Application/Services → Domain → Infrastructure/Data access — mirroring the handler → service → repository layering in `ai/rules/architecture.md`, adapted to .NET project/folder boundaries.
- Repository/data-access methods return domain-specific results (nullable/`Result<T>`/typed not-found), never leak `DbUpdateException` or other EF Core/ADO exceptions up to the service layer.
- Use dependency injection via the built-in container (`IServiceCollection`) — avoid `static` singletons or service locators.
- Testing: xUnit for unit/integration tests, a mocking library (NSubstitute or Moq) for interfaces, and `WebApplicationFactory` for integration tests against the real ASP.NET pipeline (matching the testcontainers approach in `ai/rules/testing.md` for the database layer).
- Enforce HTTPS and configure CORS explicitly per environment — never `AllowAnyOrigin` in production.
- Nullable reference types are enabled (`<Nullable>enable</Nullable>`) — treat nullable warnings as real, not noise to suppress.
