---
name: testing
description: Choosing unit vs integration vs E2E tests. Use when deciding test strategy for a change.
---

# Testing Skill

## Responsible for

Deciding what kind of test a change actually needs, at what layer, so coverage is deliberate rather than reflexive.

## Follows

- `ai/rules/testing.md` for the enforced baseline (unit/integration/E2E requirements, testcontainers, flaky-test handling)
- `ai/skills/playwright/SKILL.md` for E2E specifics

## The testing pyramid, applied here

1. **Unit tests** — service-layer business logic, against fakes/mocks at the repository boundary. This is where most tests should live: fast, no I/O, one behavior per test. See `ai/examples/test.md` for the canonical table-driven shape.
2. **Integration tests** — repository layer against a real database via testcontainers (`ai/rules/testing.md`), including RLS/tenant-isolation behavior that can't be faked convincingly. Fewer of these than unit tests; each one costs real time to run.
3. **End-to-end tests** — Playwright, covering user-facing flows end-to-end (`ai/skills/playwright/SKILL.md`). Fewest of all: these are the slowest and most brittle layer, reserved for flows that matter enough to justify the cost.

## Deciding where a new test belongs

- If it can be expressed as "given this input, this function returns/does X" without touching a database or network — unit test.
- If it's specifically testing that a query, migration, or RLS policy behaves correctly against a real database — integration test.
- If it's testing that a real user, clicking through the real UI, can complete a real task — E2E test. Don't reach for Playwright to test something a unit test could verify faster and more reliably.

## Common anti-patterns to flag in review

- An E2E test doing what a unit test should (e.g. asserting a validation error message's exact wording) — slow feedback loop for no added confidence.
- A unit test that spins up a real database "just to be safe" — that's an integration test wearing a unit test's name, and it'll be slow and flaky as the suite grows.
- Skipped/flaky tests left indefinitely (`t.Skip()`, `test.skip()`) — per `ai/rules/testing.md`, a flaky test is a P1 bug, not background noise to route around.
