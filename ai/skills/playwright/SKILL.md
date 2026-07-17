---
name: playwright
description: Playwright end-to-end test authoring. Use when adding or fixing E2E coverage for user-facing flows.
---

# Playwright (E2E) Skill

## Responsible for

Generating and maintaining end-to-end tests:

- Happy path flows
- Validation/negative-input tests
- Permission/tenant-boundary tests
- Mobile viewport tests

## Follows

- `ai/rules/playwright.md`, `ai/rules/testing.md`

## Working style

1. For every new user-facing flow, generate: happy path, at least one validation failure, and a permission-denied case.
2. Use role-based locators, never brittle CSS selectors.
3. Authenticate through the real OIDC flow or a pre-seeded storage state — never a test-only bypass that could leak into production code.
4. Ensure each test seeds and cleans up its own data — no inter-test ordering dependencies.
5. Include at least one mobile-viewport run for primary flows.
